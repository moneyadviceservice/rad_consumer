RSpec.describe SearchFormSerializer do
  let(:default_params) { { pension_pot_size: SearchForm::ANY_SIZE_VALUE } }
  let(:params) { default_params }
  let(:search_form) { SearchForm.new(params) }

  subject { described_class.new(search_form) }

  describe '#query' do
    let(:query_hash) { subject.query[:filtered][:query] }
    let(:filter_hash) { subject.query[:filtered][:filter] }

    describe 'firm_id filter' do
      context 'no firm_id is included in the search form params' do
        let(:params) { default_params.merge(firm_id: nil) }

        it 'includes a term filter to limit the query to the one firm id' do
          expect(query_hash).to eq(bool: { must: [] })
        end
      end

      context 'a firm_id is included in the search form params' do
        let(:params) { default_params.merge(firm_id: 123) }

        it 'includes a term filter to limit the query to the one firm id' do
          expect(query_hash).to eq(bool: { must: [{ term: { _id: 123 } }] })
        end
      end
    end

    describe 'qualification filter' do
      context 'no selected_qualification_id is included in the search form params' do
        before do
          allow(search_form).to receive(:selected_qualification_id).and_return(nil)
        end

        it 'builds an empty filter' do
          expect(filter_hash).to eq(bool: { must: [] })
        end
      end

      context 'a selected_qualification_id is included in the search form params' do
        before do
          allow(search_form).to receive(:selected_qualification_id).and_return(123)
        end

        it 'includes an `in` filter for `adviser_qualification_ids`' do
          expect(filter_hash).to eq(bool: { must: [{ in: { adviser_qualification_ids: [123] } }] })
        end
      end
    end

    describe 'accreditation filter' do
      context 'no selected_accreditation_id is included in the search form params' do
        before do
          allow(search_form).to receive(:selected_accreditation_id).and_return(nil)
        end

        it 'builds an empty filter' do
          expect(filter_hash).to eq(bool: { must: [] })
        end
      end

      context 'a selected_accreditation_id is included in the search form params' do
        before do
          allow(search_form).to receive(:selected_accreditation_id).and_return(123)
        end

        it 'includes an `in` filter for `adviser_accreditation_ids`' do
          expect(filter_hash).to eq(bool: { must: [{ in: { adviser_accreditation_ids: [123] } }] })
        end
      end
    end

    context 'the pension pot size is "any size"' do
      it 'does not include a match filter for investment sizes' do
        expect(query_hash).to eq(bool: { must: [] })
      end
    end

    context 'the pension pot size is set to a value' do
      let(:params) { default_params.merge(pension_pot_size: '3') }

      it 'includes a filter for the investment size' do
        expect(query_hash).to eq(bool: { must: [{ match: { investment_sizes: '3' } }] })
      end
    end

    context 'when phone or online' do
      before do
        params.merge!(
          advice_method: SearchForm::ADVICE_METHOD_PHONE_OR_ONLINE,
          random_search_seed: 1234
        )
      end

      it 'performs a randomly seeded search' do
        expect(subject.query[:function_score]).to include(random_score: { seed: 1234 })
      end
    end
  end

  describe '#sort' do
    it 'is `registered_name` by default' do
      expect(subject.sort).to eq(['registered_name'])
    end

    context 'when face to face' do
      before do
        params.merge!(
          advice_method: SearchForm::ADVICE_METHOD_FACE_TO_FACE,
          postcode: 'EC1N 2TD'
        )
      end

      it 'sorts by geo distance first' do
        VCR.use_cassette(:geocode_search_form_postcode) do
          expect(subject.sort.first).to eq(_geo_distance: {
                                             'advisers.location' => [-0.1085203, 51.5180697],
                                             order: 'asc',
                                             unit: 'miles'
                                           })
        end
      end

      it 'sorts by `registered_name` second' do
        VCR.use_cassette(:geocode_search_form_postcode) do
          expect(subject.sort.last).to eq('registered_name')
        end
      end
    end

    context 'when phone or online' do
      before do
        params.merge!(
          advice_method: SearchForm::ADVICE_METHOD_PHONE_OR_ONLINE
        )
      end

      it 'sorts by `_score` first' do
        expect(subject.sort.first).to eq('_score')
      end
    end
  end
end
