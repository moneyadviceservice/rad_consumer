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
        before { form.postcode = 'ABC' }

        it 'is not valid' do
          expect(form).to_not be_valid
        end
      end
    end
  end

  describe '#pension_pot?' do
    subject(:pension_pot?) { form.pension_pot? }

    context 'when the value for `pension_pot` is 1' do
      let(:form) { described_class.new(pension_pot: '1') }

      it { is_expected.to be_truthy }
    end

    context 'when the value for `pension_pot` is not present' do
      let(:form) { described_class.new(pension_pot: nil) }

      it { is_expected.to be_falsey }
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
      expect(form.pension_pot_sizes.last).to eql([I18n.t('search_filter.pension_pot.any_size_option'), SearchForm::ANY_SIZE_VALUE])
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

  describe '#pension_pot_transfer?' do
    subject(:pension_pot_transfer?) { form.pension_pot_transfer? }

    context 'when `pension_pot_transfer` is 1' do
      let(:form) { described_class.new(pension_pot_transfer: '1') }

      it { is_expected.to be_truthy }
    end

    context 'when `pension_pot_transfer` is not present' do
      let(:form) { described_class.new(pension_pot_transfer: nil) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#to_query' do
    let(:serializer) { double }

    context 'when advice method is face to face' do
      let(:form) { described_class.new(advice_method: SearchForm::ADVICE_METHOD_FACE_TO_FACE, postcode: 'ABC 123') }

      before do
        allow(Geocode).to receive(:call).and_return(true)
        allow(SearchFormSerializer).to receive(:new).and_return(serializer)
      end

      it 'builds the query JSON via the `SearchFormSerializer`' do
        expect(serializer).to receive(:as_json)

        form.to_query
      end
    end

    context 'when advice method is phone or online' do
      let(:form) { described_class.new(advice_method: SearchForm::ADVICE_METHOD_PHONE_OR_ONLINE) }

      before { allow(RemoteSearchFormSerializer).to receive(:new).and_return(serializer) }

      it 'builds the query JSON via the `RemoteSearchFormSerializer`' do
        expect(serializer).to receive(:as_json)

        form.to_query
      end
    end
  end
end
