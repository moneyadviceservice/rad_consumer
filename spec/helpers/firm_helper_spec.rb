require 'spec_helper'

RSpec.describe FirmHelper, type: :helper do
  let(:firm) { double }

  describe 'type_of_advice_list_item' do
    subject { helper.type_of_advice_list_item(firm, :equity_release) }

    context 'it does not have the advice type' do
      before do
        allow(firm).to receive(:includes_advice_type?).and_return(false)
      end

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'has the advice type' do
      before do
        allow(firm).to receive(:includes_advice_type?).and_return(true)
      end

      it 'returns a list item element containing the corresponding translation' do
        expect(subject).to eq('<li class="types-of-advice__list-item">Equity release</li>')
      end
    end
  end

  describe 'closest_adviser_text' do
    before do
      allow(firm).to receive(:closest_adviser).and_return(closest_adviser)
    end

    subject { helper.closest_adviser_text(firm) }

    context 'when the adviser is less than 1 mile away' do
      let(:closest_adviser) { '0.1358' }
      it { is_expected.to eq('0.1 miles away') }
    end

    context 'when the adviser is exactly 1 mile away' do
      let(:closest_adviser) { '1.0' }
      it { is_expected.to eq('1.0 miles away') }
    end

    context 'when the adviser is greater than 1 mile away' do
      let(:closest_adviser) { '1.12345678' }
      it { is_expected.to eq('1.1 miles away') }
    end

    context 'when the adviser is exactly 2 miles away' do
      let(:closest_adviser) { '2.00000' }
      it { is_expected.to eq('2.0 miles away') }
    end
  end

  describe 'minimum_pot_size_text' do
    let(:available_ordinals) { I18n.t('investment_size.ordinal').keys.map(&:to_s).map(&:to_i) }
    let(:lowest_size) { InvestmentSize.lowest }
    let(:other_size) { InvestmentSize.where.not(order: lowest_size.order).first }
    let(:expected_friendly_name) { I18n.t("investment_size.ordinal.#{other_size.order}") }
    subject { helper.minimum_pot_size_text(firm) }

    before do
      available_ordinals.each do |ordinal|
        FactoryGirl.create(:investment_size, order: ordinal)
      end
      allow(firm).to receive(:investment_sizes).and_return(firm_investment_sizes.map(&:id))
    end

    context 'when the minimum size is not `Under £50k`' do
      let(:firm_investment_sizes) { [other_size] }

      it { is_expected.to eq(expected_friendly_name) }
    end

    context 'when the minimum size is `Under £50k`' do
      let(:firm_investment_sizes) { [lowest_size, other_size] }

      it { is_expected.to eq(I18n.t('investment_size.no_minimum')) }
    end
  end
end
