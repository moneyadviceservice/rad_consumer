RSpec.describe RemoteSearchForm do
  describe '#to_query' do
    let(:serializer) { double }

    before do
      allow(RemoteSearchFormSerializer).to receive(:new).and_return(serializer)
    end

    subject { described_class.new(advice_methods: ["1"]) }

    it 'builds the query JSON via the `SearchFormSerializer`' do
      expect(serializer).to receive(:as_json)

      subject.to_query
    end
  end
end
