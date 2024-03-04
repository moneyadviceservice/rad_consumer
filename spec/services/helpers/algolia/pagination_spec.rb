RSpec.describe Helpers::Algolia::Randomisation, type: :helper do
  describe '.paginate' do
    subject(:paginate) do
      helper.paginate(**hash, page:, hits_per_page:)
    end
    let(:hash) { { some: :values } }
    let(:page) { 1 }
    let(:hits_per_page) { 10 }

    context 'invalid page' do
      let(:page) { 0 }

      it 'raises an error' do
        expect { paginate }.to raise_error(described_class::PageRangeError)
      end
    end

    context 'page exceeding the max page limit' do
      let(:page) { 1_001 }

      it 'raises an error' do
        expect { paginate }.to raise_error(described_class::PageRangeError)
      end
    end

    context 'first page' do
      it 'adds pagination' do
        new_hash = paginate
        expect(new_hash).to eq(hash.merge(page: 0, hitsPerPage: hits_per_page))
      end
    end

    context 'page other than 1' do
      let(:page) { 2 }

      it 'adds pagination' do
        new_hash = paginate
        expect(new_hash).to eq(hash.merge(page: 1, hitsPerPage: hits_per_page))
      end
    end
  end
end
