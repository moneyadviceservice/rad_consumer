RSpec.describe SearchFormSerializer do
  let(:default_params) { { pension_pot_size: SearchForm::ANY_SIZE_VALUE } }
  let(:params) { default_params }
  let(:search_form) { SearchForm.new(params) }

  subject { described_class.new(search_form) }

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
