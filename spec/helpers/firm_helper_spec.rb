require 'spec_helper'

RSpec.describe FirmHelper, type: :helper do
  let(:firm) { double }

  describe 'firm_has_investing_types?' do
    subject { helper.firm_has_investing_types?(firm) }

    context 'it has neither sharia or ethical investing' do
      before do
        allow(firm).to receive(:ethical_investing_flag).and_return(false)
        allow(firm).to receive(:sharia_investing_flag).and_return(false)
      end

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'it has sharia but not ethical investing' do
      before do
        allow(firm).to receive(:ethical_investing_flag).and_return(false)
        allow(firm).to receive(:sharia_investing_flag).and_return(true)
      end

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'it has ethical but not sharia investing' do
      before do
        allow(firm).to receive(:ethical_investing_flag).and_return(true)
        allow(firm).to receive(:sharia_investing_flag).and_return(false)
      end

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'it has ethical and sharia investing' do
      before do
        allow(firm).to receive(:ethical_investing_flag).and_return(true)
        allow(firm).to receive(:sharia_investing_flag).and_return(true)
      end

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
  end

  describe 'type_of_advice_list_item' do
    subject { helper.type_of_advice_list_item(firm, :equity_release, 'list-item-style') }

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
        expect(subject).to eq('<li class="list-item-style">Equity release</li>')
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

  describe 'minimum_fixed_fee' do
    context 'displays values in GBP' do
      before { allow(firm).to receive(:minimum_fixed_fee).and_return(10) }

      it { expect(helper.minimum_fixed_fee(firm)).to eq('£10') }
    end

    context 'displays values in whole GBP' do
      before { allow(firm).to receive(:minimum_fixed_fee).and_return(20.9) }

      it { expect(helper.minimum_fixed_fee(firm)).to eq('£21') }
    end
  end

  describe 'ensure_external_link_has_protocol' do
    context 'when the link protocol is http or https' do
      let(:http_link) { 'http://example.org' }
      let(:https_link) { 'https://example.org' }

      it 'remains unchanged' do
        expect(helper.ensure_external_link_has_protocol(http_link)).to eq(http_link)
        expect(helper.ensure_external_link_has_protocol(https_link)).to eq(https_link)
      end
    end

    context 'when the link does not have a protocol' do
      let(:link) { 'example.org' }

      it 'adds the http protocol' do
        expect(helper.ensure_external_link_has_protocol(link)).to eq('http://example.org')
      end
    end
  end

  describe 'firm_language_list' do
    context 'when passed an empty list' do
      it 'returns only English' do
        expect(firm_language_list([])).to eq(['English'])
      end
    end

    context 'when passed list of 3 letter language codes' do
      it 'returns English and the given codes translated to their common names' do
        expect(firm_language_list(%w(spa por aae)))
          .to match_array(['English', 'Spanish', 'Portuguese', 'Arbëreshë Albanian'])
      end

      it 'returns the list alphabetically sorted' do
        expect(firm_language_list(%w(spa por aae)))
          .to eq(['Arbëreshë Albanian', 'English', 'Portuguese', 'Spanish'])
      end
    end
  end
end
