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
      let(:advice_method) { Filters::AdviceMethod::ADVICE_METHOD_FACE_TO_FACE }

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
      let(:advice_method) { Filters::AdviceMethod::ADVICE_METHOD_PHONE_OR_ONLINE }

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

    context 'when advice method is firm name search' do
      let(:advice_method) { Filters::AdviceMethod::ADVICE_METHOD_FIRM_NAME_SEARCH }

      describe '#face_to_face?' do
        it 'returns falsey' do
          expect(form.face_to_face?).to be_falsey
        end
      end

      describe '#phone_or_online?' do
        it 'returns falsey' do
          expect(form.phone_or_online?).to be_falsey
        end
      end

      describe '#firm_name_search?' do
        it 'returns truthy' do
          expect(form.firm_name_search?).to be_truthy
        end
      end
    end
  end

  context 'for the face to face advice method' do
    let(:form) do
      described_class.new(advice_method: Filters::AdviceMethod::ADVICE_METHOD_FACE_TO_FACE, postcode: 'rg2 1aa')
    end

    it 'upcases the postcode before validation' do
      VCR.use_cassette(:geocoded_postcode) do
        form.validate

        expect(form.postcode).to eql('RG2 1AA')
      end
    end
  end

  describe '#types_of_advice' do
    let(:form) { described_class.new(types_of_advice) }

    Filters::TypeOfAdvice::TYPES_OF_ADVICE.each do |advice_type|
      context "#{advice_type} set" do
        let(:types_of_advice) { { advice_type => '1' } }
        it "contains #{advice_type}" do
          expect(form.types_of_advice).to eql([advice_type])
        end
      end
    end

    context 'multiple flags set' do
      let(:types_of_advice) { { pension_transfer_flag: '1', inheritance_tax_and_estate_planning_flag: '1' } }
      it 'contains both flag' do
        expect(form.types_of_advice).to eql(%i[pension_transfer_flag inheritance_tax_and_estate_planning_flag])
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
      let(:types_of_advice) { { equity_release_flag: '1' } }

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

    context 'workplace financial advice flag service set' do
      context 'setting_up_workplace_pension_flag' do
        let(:services) { { setting_up_workplace_pension_flag: '1' } }
        it 'contains workplace_financial_advice_flag' do
          expect(form.services).to eql([:workplace_financial_advice_flag])
        end
      end
      context 'existing_workplace_pension_flag' do
        let(:services) { { existing_workplace_pension_flag: '1' } }
        it 'contains workplace_financial_advice_flag' do
          expect(form.services).to eql([:workplace_financial_advice_flag])
        end
      end
      context 'advice_for_employees_flag' do
        let(:services) { { advice_for_employees_flag: '1' } }
        it 'contains workplace_financial_advice_flag' do
          expect(form.services).to eql([:workplace_financial_advice_flag])
        end
      end

      context 'multiple workplace financial advice options' do
        let(:services) do
          {
            setting_up_workplace_pension_flag: '1',
            existing_workplace_pension_flag: '1',
            advice_for_employees_flag: '1'
          }
        end

        it 'contains one workplace_financial_advice_flag' do
          expect(form.services).to eql([:workplace_financial_advice_flag])
        end
      end
    end

    context 'all flags set' do
      let(:services) do
        { sharia_investing_flag: '1',
          ethical_investing_flag: '1',
          setting_up_workplace_pension_flag: '1' }
      end

      it 'contains both flag' do
        expect(form.services).to eql(%i[ethical_investing_flag
                                        sharia_investing_flag
                                        workplace_financial_advice_flag])
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
      let(:advice_method) { Filters::AdviceMethod::ADVICE_METHOD_FACE_TO_FACE }

      context 'and a correctly formatted postcode is present' do
        before { form.postcode = 'RG2 1AA' }

        it 'is valid' do
          VCR.use_cassette(:geocoded_postcode) do
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
        expect(form.remote_advice_method_ids).to be_empty
      end
    end

    context 'when advice method is phone or online' do
      let(:advice_method) { Filters::AdviceMethod::ADVICE_METHOD_PHONE_OR_ONLINE }

      it 'passes on phone and online' do
        expected_method_ids = %i[1 2]
        expect(form.remote_advice_method_ids).to eq(expected_method_ids)
      end

      it 'does not pass on the postcode' do
        form.postcode = 'RG2 1AA'
        expect(form.postcode).to be_nil
      end
    end
  end

  describe '#retirement_income_products_flag?' do
    context 'when the option is selected' do
      subject { described_class.new(retirement_income_products_flag: '1') }

      it '#retirement_income_products_flag? is truthy' do
        expect(subject).to be_retirement_income_products_flag
      end
    end

    context 'when the option is not selected' do
      subject { described_class.new(retirement_income_products_flag: nil) }

      it '#retirement_income_products_flag? is falsey' do
        expect(subject).to_not be_retirement_income_products_flag
      end
    end
  end

  describe '#options_for_investment_sizes' do
    let(:form) { described_class.new }

    it 'returns the localized name and ID for each investment size' do
      expected_list = [
        ['Under £50,000', '1'],
        ['£50,000', '2'],
        ['£100,000', '3'],
        ['Over £150,000', '4']
      ]

      expect(form.options_for_investment_sizes).to include(*expected_list)
    end

    it 'returns the any size option as the first element' do
      expected = [
        I18n.t('search_filter.investment_size.any_size_option'), SearchForm::ANY_SIZE_VALUE
      ]
      expect(form.options_for_investment_sizes.first).to eql(expected)
    end
  end

  describe '#options_for_languages' do
    let(:form) { described_class.new }

    it 'returns the LanguageInfo for each iso_639_3 code sorted by common name' do
      supported_languages = %w[
        afr ara ben bfi bul cym dan deu ell fas fra guj hin ita
        mar nld pan pol por ron rus spa sqi tur ukr urd vie zho
      ]
      expected_list = supported_languages.map do |language|
        LanguageList::LanguageInfo.find(language)
      end

      expect(form.options_for_language).to match_array(expected_list)
    end
  end

  describe '#options_for_qualifications_and_accreditations' do
    let(:form) { described_class.new }

    context 'for all qualifications and accreditations that have translation keys' do
      it 'provides a list of alphabetically ordered options ' do
        expected_list = [
          ['Chartered Associate of The London Institute of Banking &amp; Finance', 'q12'],
          ['Chartered Fellow of The London Institute of Banking & Finance', 'q13'],
          ['Certified Financial Planner', 'q4'],
          ['Chartered Financial Planner', 'q3'],
          ['Chartered Wealth Manager', 'q10'],
          ['ISO 22222', 'a3'],
          ['Pension Transfer Gold Standard', 'q11'],
          %w[SOLLA a1]
        ]
        expect(form.options_for_qualifications_and_accreditations)
          .to eql(expected_list)
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

  describe '#pension_transfer_flag' do
    let(:form) do
      described_class.new(
        pension_transfer_flag: pension_transfer_flag,
        long_term_care_flag: '1',
        equity_release_flag: '1',
        inheritance_tax_and_estate_planning_flag: '1',
        wills_and_probate_flag: '1'
      )
    end

    context 'when retirement products is selected' do
      before { form.retirement_income_products_flag = '1' }

      let(:pension_transfer_flag) { '1' }

      it 'returns the value for pension transfer' do
        expect(form.pension_transfer_flag).to eql(pension_transfer_flag)
      end
    end

    context 'when retirement products is not selected' do
      before { form.retirement_income_products_flag = nil }

      context 'but pension transfer is selected' do
        let(:pension_transfer_flag) { '1' }

        it 'still returns "1"' do
          expect(form.pension_transfer_flag).to eql('1')
        end
      end
    end
  end

  describe '#as_json' do
    let(:serializer) { double }
    let(:form) do
      described_class.new(
        long_term_care_flag: '1',
        equity_release_flag: '1',
        inheritance_tax_and_estate_planning_flag: '1',
        wills_and_probate_flag: '1'
      )
    end

    before do
      allow(Geocode).to receive(:call).and_return(true)
    end

    it 'builds the query JSON' do
      expected_hash = {
        long_term_care_flag: '1',
        equity_release_flag: '1',
        inheritance_tax_and_estate_planning_flag: '1',
        wills_and_probate_flag: '1'
      }.with_indifferent_access

      expect(form.as_json).to eq(expected_hash)
    end
  end

  describe '#new' do
    it 'gracefully discards unsupported params' do
      expect(described_class.attribute_method?('pension_pot_size')).to be_falsey
      expect(described_class.attribute_method?('advice_method')).to be_truthy
      expect { described_class.new(pension_pot_size: 'any', advice_method: 'face_to_face') }.to_not raise_exception
    end
  end
end
