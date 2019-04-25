require 'spec_helper'

RSpec.describe SearchHelper, type: :helper do
  describe '#firm_has_qualifications_or_accreditations?' do
    subject { helper.firm_has_qualifications_or_accreditations?(firm) }

    let(:firm) do
      double(Results::FirmPresenter,
             adviser_qualification_ids: adviser_qualification_ids,
             adviser_accreditation_ids: adviser_accreditation_ids)
    end

    let(:no_qualifications) { [] }
    let(:no_accreditations) { [] }
    let(:ignored_qualifications) do
      I18n.t('qualification.ordinal')
          .select { |_k, v| v == 'ignored' }
          .keys.map(&:to_s).map(&:to_i)
    end
    let(:ignored_accreditations) do
      I18n.t('accreditation.ordinal')
          .select { |_k, v| v == 'ignored' }
          .keys.map(&:to_s).map(&:to_i)
    end
    let(:visible_qualifications) do
      I18n.t('qualification.ordinal')
          .reject { |_k, v| v == 'ignored' }
          .keys.map(&:to_s).map(&:to_i)
    end
    let(:visible_accreditations) do
      I18n.t('accreditation.ordinal')
          .reject { |_k, v| v == 'ignored' }
          .keys.map(&:to_s).map(&:to_i)
    end

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
end
