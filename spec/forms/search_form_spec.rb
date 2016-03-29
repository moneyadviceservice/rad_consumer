RSpec.describe SearchForm do
  describe 'advice method predicates' do
    let(:form) { described_class.new(advice_method: advice_method) }

    describe 'attributes' do
      it 'allows firm_id to be set and accessed' do
        subject.firm_id = 123
        expect(subject.firm_id).to eq(123)
      end
    end

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

  describe '#types_of_advice' do
    let(:form) { described_class.new(types_of_advice) }

    SearchForm::TYPES_OF_ADVICE.each do |advice_type|
      context "#{advice_type} set" do
        let(:types_of_advice) { { advice_type => '1' } }
        it "contains #{advice_type}" do
          expect(form.types_of_advice).to eql([advice_type])
        end
      end
    end

    context 'multiple flags set' do
      let(:types_of_advice) { { pension_transfer: '1', inheritance_tax_planning: '1' } }
      it 'contains both flag' do
        expect(form.types_of_advice).to eql([:pension_transfer, :inheritance_tax_planning])
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

  describe '#services' do
    let(:form) { described_class.new(services) }

    context 'ethical investment flag set' do
      let(:services) { { ethical_investing_flag: '1' } }
      it 'contains ethical_investing_flag' do
        expect(form.services).to eql([:ethical_investing_flag])
      end
    end

    context 'sharia investment flag set' do
      let(:services) { { sharia_investing_flag: '1' } }
      it 'contains sharia_investing_flag' do
        expect(form.services).to eql([:sharia_investing_flag])
      end
    end

    context 'non uk residents flag set' do
      let(:services) { { non_uk_residents_flag: '1' } }
      it 'contains non_uk_residents_flag' do
        expect(form.services).to eql([:non_uk_residents_flag])
      end
    end

    context 'both flags set' do
      let(:services) { { sharia_investing_flag: '1', ethical_investing_flag: '1' } }
      it 'contains both flag' do
        expect(form.services).to eql([:ethical_investing_flag, :sharia_investing_flag])
      end
    end
  end

  describe '#services?' do
    let(:form) { described_class.new(services) }

    context 'when no types of advice are selected' do
      let(:services) { {} }

      it 'returns false' do
        expect(form.services?).to be(false)
      end
    end

    context 'when one or more types of advice are selected' do
      let(:services) { { sharia_investing_flag: '1' } }

      it 'returns true' do
        expect(form.services?).to be(true)
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

      it 'does not pass on any advice methods' do
        OtherAdviceMethod.create name: 'phone'
        expect(form.remote_advice_method_ids).to be_empty
      end
    end

    context 'when advice method is phone or online' do
      let(:advice_method) { SearchForm::ADVICE_METHOD_PHONE_OR_ONLINE }

      it 'passes on phone and online' do
        phone = OtherAdviceMethod.create name: 'phone'
        online = OtherAdviceMethod.create name: 'online'
        expect(form.remote_advice_method_ids).to eq([phone.id, online.id])
      end

      it 'does not pass on the postcode' do
        form.postcode = 'RG2 1AA'
        expect(form.postcode).to be_nil
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

  describe '#options_for_pension_pot_sizes' do
    let(:form) { described_class.new }

    let(:investment_sizes) { create_list(:investment_size, 3) }

    before { allow(InvestmentSize).to receive(:all).and_return(investment_sizes) }

    it 'returns the localized name and ID for each investment size' do
      tuples = investment_sizes.map { |i| [i.localized_name, i.id] }

      expect(form.options_for_pension_pot_sizes).to include(*tuples)
    end

    it 'returns the any size option as the last element' do
      expect(form.options_for_pension_pot_sizes.last).to eql([
        I18n.t('search_filter.pension_pot.any_size_option'), SearchForm::ANY_SIZE_VALUE
      ])
    end
  end

  describe '#options_for_languages' do
    let(:form) { described_class.new }

    before { allow(Firm).to receive(:languages_used).and_return(%w(sco swe de)) }

    it 'returns the LanguageInfo for each iso_639_3 code sorted by common name' do
      german = LanguageList::LanguageInfo.find 'de'
      swedish = LanguageList::LanguageInfo.find 'swe'
      scots = LanguageList::LanguageInfo.find 'sco'
      expect(form.options_for_language).to eql([german, scots, swedish])
    end
  end

  describe '#options_for_qualifications_and_accreditations' do
    let(:form) { described_class.new }

    before :each do
      Qualification.create(id: 1, order: 1, name: 'Should not be returned in the resulting options')
      Qualification.create(id: 2, order: 3, name: 'Chartered Financial Planner')
      Qualification.create(id: 3, order: 4, name: 'Certified Financial Planner')
      Qualification.create(
        id: 4, order: 5, name: 'Pension transfer qualifications - holder of G60, AF3, AwPETR®, or equivalent')

      Accreditation.create(id: 4, order: 1, name: 'SOLLA')
      Accreditation.create(id: 5, order: 2, name: 'Later Life Academy')
      Accreditation.create(id: 6, order: 3, name: 'ISO 22222')
    end

    context 'for all qualifications and accreditations that have translation keys' do
      it 'provides a list of alphabetically ordered options ' do
        expected_list = [
          ['Certified Financial Planner', 'q3'],
          ['Chartered Financial Planner', 'q2'],
          ['ISO 22222', 'a6'],
          ['Later Life Academy', 'a5'],
          %w(SOLLA a4) # Rubocop expects %w for this row
        ]
        expect(form.options_for_qualifications_and_accreditations).to eql(expected_list)
      end
    end
  end

  describe '#selected_qualification_id' do
    let(:form) { described_class.new }
    subject { form.selected_qualification_id }

    context 'when a qualification filter has been selected' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return('q4')
      end

      it { is_expected.to eql(4) }
    end

    context 'when an accreditation filter has been selected' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return('a4')
      end

      it { is_expected.to be_nil }
    end

    context 'when the blank filter has been selected' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return('')
      end

      it { is_expected.to be_nil }
    end

    context 'when the filter is not set' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return(nil)
      end

      it { is_expected.to be_nil }
    end
  end

  describe '#selected_accreditation_id' do
    let(:form) { described_class.new }
    subject { form.selected_accreditation_id }

    context 'when an accreditation filter has been selected' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return('a4')
      end

      it { is_expected.to eql(4) }
    end

    context 'when a qualification filter has been selected' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return('q4')
      end

      it { is_expected.to be_nil }
    end

    context 'when the blank filter has been selected' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return('')
      end

      it { is_expected.to be_nil }
    end

    context 'when the filter is not set' do
      before do
        allow(form).to receive(:qualification_or_accreditation).and_return(nil)
      end

      it { is_expected.to be_nil }
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

        it 'still returns "1"' do
          expect(form.pension_transfer).to eql('1')
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
