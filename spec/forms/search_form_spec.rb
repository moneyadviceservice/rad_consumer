RSpec.describe SearchForm do
  describe 'advice method predicates' do
    let(:form) { described_class.new(advice_method: advice_method) }

    context 'when advice method is face to face' do
      let(:advice_method) { SearchForm::ADVICE_METHOD_FACE_TO_FACE }

      describe '#face_to_face?' do
        it 'returns truthy' do
          expect(form.face_to_face?).to be_truthy
        end
      end

      describe '#phone_or_online?' do
        it 'returns falsey' do
          expect(form.phone_or_online?).to be_falsey
        end
      end
    end

    context 'when advice method is phone or online' do
      let(:advice_method) { SearchForm::ADVICE_METHOD_PHONE_OR_ONLINE }

      describe '#face_to_face?' do
        it 'returns falsey' do
          expect(form.face_to_face?).to be_falsey
        end
      end

      describe '#phone_or_online?' do
        it 'returns truthy' do
          expect(form.phone_or_online?).to be_truthy
        end
      end
    end
  end

  context 'for the face to face advice method' do
    let(:form) { described_class.new(advice_method: SearchForm::ADVICE_METHOD_FACE_TO_FACE, postcode: 'rg2 1aa') }

    it 'upcases the postcode before validation' do
      VCR.use_cassette(:rg2_1aa) do
        form.validate

        expect(form.postcode).to eql('RG2 1AA')
      end
    end
  end

  describe '#types_of_advice?' do
    let(:form) { described_class.new(types_of_advice) }

    context 'when no types of advice are selected' do
      let(:types_of_advice) { {} }

      it 'returns false' do
        expect(form.types_of_advice?).to be(false)
      end
    end

    context 'when one or more types of advice are selected' do
      let(:types_of_advice) { { equity_release: '1' } }

      it 'returns true' do
        expect(form.types_of_advice?).to be(true)
      end
    end
  end

  describe 'validation' do
    let(:form) { described_class.new(advice_method: advice_method) }

    context 'when no advice method is present' do
      let(:advice_method) { nil }

      it 'is not valid' do
        expect(form).not_to be_valid
      end
    end

    context 'when the advice method is face to face' do
      let(:advice_method) { SearchForm::ADVICE_METHOD_FACE_TO_FACE }

      context 'and a correctly formatted postcode is present' do
        before { form.postcode = 'RG2 1AA' }

        it 'is valid' do
          VCR.use_cassette(:rg2_1aa) do
            expect(form).to be_valid
          end
        end

        context 'but cannot be geocoded' do
          before { form.postcode = 'ZZ1 1ZZ' }

          it 'is not valid' do
            allow(Geocode).to receive(:call).and_return(false)

            expect(form).to_not be_valid
          end
        end
      end

      context 'and no postcode is present' do
        it 'is not valid' do
          expect(form).to_not be_valid
        end
      end

      context 'and a badly formatted postcode is present' do
        before { form.postcode = 'Z' }

        it 'is not valid' do
          expect(form).to_not be_valid
        end
      end
    end

    context 'when advice method is phone or online' do
      let(:advice_method) { SearchForm::ADVICE_METHOD_PHONE_OR_ONLINE }

      context 'and either phone or online is present' do
        before {  form.advice_methods = ['1'] }

        it 'is valid' do
          expect(form).to be_valid
        end
      end

      context 'and neither phone or online is present' do
        before {  form.advice_methods = [] }

        it 'is not valid' do
          expect(form).not_to be_valid
        end
      end
    end
  end

  describe '#retirement_income_products?' do
    context 'when the option is selected' do
      subject { described_class.new(retirement_income_products: '1') }

      it '#retirement_income_products? is truthy' do
        expect(subject).to be_retirement_income_products
      end
    end

    context 'when the option is not selected' do
      subject { described_class.new(retirement_income_products: nil) }

      it '#retirement_income_products? is falsey' do
        expect(subject).to_not be_retirement_income_products
      end
    end
  end

  describe '#pension_pot_sizes' do
    let(:form) { described_class.new }

    let(:investment_sizes) { create_list(:investment_size, 3) }

    before { allow(InvestmentSize).to receive(:all).and_return(investment_sizes) }

    it 'returns the localized name and ID for each investment size' do
      tuples = investment_sizes.map { |i| [i.localized_name, i.id] }

      expect(form.pension_pot_sizes).to include(*tuples)
    end

    it 'returns the any size option as the last element' do
      expect(form.pension_pot_sizes.last).to eql([
        I18n.t('search_filter.pension_pot.any_size_option'), SearchForm::ANY_SIZE_VALUE
      ])
    end
  end

  describe '#any_pension_pot_size?' do
    subject(:any_pension_pot_size?) { form.any_pension_pot_size? }

    context 'when any pension pot size is indicated' do
      let(:form) { described_class.new(pension_pot_size: SearchForm::ANY_SIZE_VALUE) }

      it { is_expected.to be_truthy }
    end

    context 'when a particular pension pot size is specified' do
      let(:form) { described_class.new(pension_pot_size: '3') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#pension_transfer' do
    let(:form) do
      described_class.new(
        pension_transfer: pension_transfer,
        options_when_paying_for_care: '1',
        equity_release: '1',
        inheritance_tax_planning: '1',
        wills_and_probate: '1'
      )
    end

    context 'when retirement products is selected' do
      before { form.retirement_income_products = '1' }

      let(:pension_transfer) { '1' }

      it 'returns the value for pension transfer' do
        expect(form.pension_transfer).to eql(pension_transfer)
      end
    end

    context 'when retirement products is not selected' do
      before { form.retirement_income_products = nil }

      context 'but pension transfer is selected' do
        let(:pension_transfer) { '1' }

        it 'returns a string zero' do
          expect(form.pension_transfer).to eql('0')
        end
      end
    end
  end

  describe '#to_query' do
    let(:serializer) { double }
    let(:form) { described_class.new }

    before do
      allow(Geocode).to receive(:call).and_return(true)
      allow(SearchFormSerializer).to receive(:new).and_return(serializer)
    end

    it 'builds the query JSON via the `SearchFormSerializer`' do
      expect(serializer).to receive(:as_json)

      form.to_query
    end
  end
end
