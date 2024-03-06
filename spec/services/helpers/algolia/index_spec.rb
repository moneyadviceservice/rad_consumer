RSpec.describe Helpers::Algolia::Index, type: :helper do
  let(:query) do
    {
      index:,
      value: [
        '',
        {
          aroundLatLng: [55.378051, -3.435973],
          facetFilters: ['firm_id:1'],
          getRankingInfo: true,
          hitsPerPage: 10,
          page: 0
        }
      ]
    }
  end
  let(:index) { :offices }

  describe '.search' do
    context 'with valid index' do
      it 'forwards the query to Algolia', :aggregate_failures do
        algolia_instance = instance_double(::Algolia::Index)

        expect(::Algolia::Index).to receive(:new)
          .with('firm-offices-test').and_return(algolia_instance)

        expect(algolia_instance).to receive(:search)
          .with(*query[:value]).exactly(:once)

        helper.search(query:)
      end
    end

    context 'with invalid index' do
      let(:index) { :invalid }

      it 'raises an error' do
        expect { helper.search(query:) }
          .to raise_error(described_class::UnvailableIndexError)
      end
    end
  end

  describe '.browse' do
    let(:algolia_instance) { instance_double(::Algolia::Index) }

    context 'when only one page can be browsed' do
      let(:response) do
        {
          hits: %i[uno dos tres],
          nbPages: 1
        }.with_indifferent_access
      end

      it 'browses the first page only and collects the hits' do
        aggregate_failures do
          expect(::Algolia::Index).to receive(:new)
            .with('firm-offices-test').and_return(algolia_instance)

          expect(algolia_instance).to receive(:search)
            .with(*query[:value]).exactly(:once).and_return(response)

          hits = helper.browse(query:)
          expect(hits).to eq(%i[uno dos tres])
        end
      end
    end

    context 'when more than one page can be browsed' do
      let(:response1) do
        {
          hits: %i[uno dos tres],
          nbPages: 2
        }.with_indifferent_access
      end
      let(:response2) do
        {
          hits: %i[quatro cinco seis],
          nbPages: 2
        }.with_indifferent_access
      end

      it 'browses all pages and collects all hits', :aggregate_failures do
        expect(::Algolia::Index).to receive(:new)
          .with('firm-offices-test').exactly(:twice).and_return(algolia_instance)

        expect(algolia_instance).to receive(:search)
          .with(*query[:value]).exactly(:once).and_return(response1, response2)

        hits = helper.browse(query:)
        expect(hits).to eq(%i[uno dos tres quatro cinco seis])
      end
    end
  end
end
