RSpec.describe FirmRepository do
  let(:client) { double }
  let(:client_class) { double(new: client) }

  describe 'initialization' do
    subject { described_class.new }

    it 'defaults `client`' do
      expect(subject.client).to be_a(ElasticSearchClient)
    end
  end

  describe '#from_for' do
    subject { described_class.new }

    it 'returns 0 for page 1' do
      expect(subject.from_for(1)).to eq(0)
    end

    it 'returns 10 for page 2' do
      expect(subject.from_for(2)).to eq(10)
    end
  end

  describe '#search' do
    it 'delegates to the configured client' do
      expect(client).to receive(:search).with('firms/_search?from=90', {})

      described_class.new(client_class).search({}, page: 10)
    end

    it 'returns the `SearchResult`' do
      allow(client).to receive(:search)

      expect(described_class.new(client_class).search({})).to be_a(SearchResult)
    end
  end

  describe '#find' do
    let(:firm) { build(:firm, id: 1) }
    let(:response_object) { { 'test' => 'works' } }
    let(:response) { double(body: response_object.to_json) }

    it 'returns the JSON parsed body' do
      allow(client).to receive(:find).with('firms/1').and_return(response)
      expect(described_class.new(client_class).find(firm)).to eq(response_object)
    end
  end
end
