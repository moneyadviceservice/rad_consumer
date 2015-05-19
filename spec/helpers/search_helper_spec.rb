require 'spec_helper'

RSpec.describe SearchHelper, type: :helper do
  describe '#firm_has_qualifications_or_accreditations?' do
    subject { helper.firm_has_qualifications_or_accreditations?(firm) }

    let(:firm) do
      double(FirmResult,
             adviser_qualification_ids: adviser_qualification_ids,
             adviser_accreditation_ids: adviser_accreditation_ids)
    end

    let(:qualification_1) do
      Qualification.create!(id: 1, name: 'Qual 1', order: 1) # Ignored
    end

    let(:qualification_2) do
      Qualification.create!(id: 2, name: 'Qual 2', order: 3) # Not ignored
    end

    let(:accreditation_1) do
      Accreditation.create!(id: 1, name: 'Accred 1', order: 4) # Ignored
    end

    let(:accreditation_2) do
      Accreditation.create!(id: 2, name: 'Accred 2', order: 1) # Not ignored
    end

    let(:no_qualifications) { [] }
    let(:no_accreditations) { [] }
    let(:ignored_qualifications) { [qualification_1.id] }
    let(:ignored_accreditations) { [accreditation_1.id] }
    let(:visible_qualifications) { [qualification_2.id] }
    let(:visible_accreditations) { [accreditation_2.id] }

    context 'with no qualifications' do
      let(:adviser_qualification_ids) { no_qualifications }

      context 'and no accreditations' do
        let(:adviser_accreditation_ids) { no_accreditations }
        it { is_expected.to be false }
      end

      context 'and ignored accreditations' do
        let(:adviser_accreditation_ids) { ignored_accreditations }
        it { is_expected.to be false }
      end

      context 'and visible accreditations' do
        let(:adviser_accreditation_ids) { visible_accreditations }
        it { is_expected.to be true }
      end
    end

    context 'with ignored qualifications' do
      let(:adviser_qualification_ids) { ignored_qualifications }

      context 'and no accreditations' do
        let(:adviser_accreditation_ids) { no_accreditations }
        it { is_expected.to be false }
      end

      context 'and ignored accreditations' do
        let(:adviser_accreditation_ids) { ignored_accreditations }
        it { is_expected.to be false }
      end

      context 'and visible accreditations' do
        let(:adviser_accreditation_ids) { visible_accreditations }
        it { is_expected.to be true }
      end
    end

    context 'with visible qualifications' do
      let(:adviser_qualification_ids) { visible_qualifications }

      context 'and no accreditations' do
        let(:adviser_accreditation_ids) { no_accreditations }
        it { is_expected.to be true }
      end

      context 'and ignored accreditations' do
        let(:adviser_accreditation_ids) { ignored_accreditations }
        it { is_expected.to be true }
      end

      context 'and visible accreditations' do
        let(:adviser_accreditation_ids) { visible_accreditations }
        it { is_expected.to be true }
      end
    end
  end

  describe '#qualification_or_accreditation_key' do
    it 'calls friendly_name on classified `kind`' do
      Fred = double
      expect(Fred).to receive(:friendly_name)
                       .with(1).and_return(:something)
      return_value = helper.qualification_or_accreditation_key(1, :fred)
      expect(return_value).to eq(:something)
    end
  end
end
