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
      it { is_expected.to eq('0.14 miles away') }
    end

    context 'when the adviser is exactly 1 mile away' do
      let(:closest_adviser) { '1.0' }
      it { is_expected.to eq('1 mile away') }
    end

    context 'when the adviser is greater than 1 mile away' do
      let(:closest_adviser) { '1.12345678' }
      it { is_expected.to eq('1.12 miles away') }
    end

    context 'when the adviser is exactly 2 miles away' do
      let(:closest_adviser) { '2.00000' }
      it { is_expected.to eq('2 miles away') }
    end
  end
end
