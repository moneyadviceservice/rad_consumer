RSpec.describe FirmProfilePresenter do
  subject do
    described_class.new(firm_result)
  end

  let(:firm_result) { double(FirmResult) }

  describe '#type_of_advice_method' do
    context 'face to face available' do
      it 'returns face_to_face' do
        expect(firm_result).to receive(:in_person_advice_methods).and_return([1, 2, 3])
        expect(subject.type_of_advice_method).to eq(:face_to_face)
      end
    end

    context 'face to face not available' do
      it 'returns remote' do
        expect(firm_result).to receive(:in_person_advice_methods).and_return([])
        expect(subject.type_of_advice_method).to eq(:remote)
      end
    end
  end
end
