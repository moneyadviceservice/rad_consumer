require 'spec_helper'

RSpec.describe FirmHelper, type: :helper do
  let(:firm) { double }

  subject { helper.type_of_advice_list_item(firm, :equity_release) }

  describe 'type_of_advice_list_item' do
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
end
