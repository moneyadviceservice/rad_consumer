RSpec.describe FetchFirmProfile do
  describe '.call' do
    subject(:perform_search) { described_class.new(**args).call }
    let(:args) do
      {
        id: 1,
        postcode: 'EC4A 2AH',
        coordinates: [51.5139284, -0.1113308],
        locale: :en
      }
    end
    let(:advisers_query) do
      {
        index: :advisers,
        value: [
          '',
          {
            aroundLatLng: [51.5139284, -0.1113308],
            distinct: false,
            facetFilters: ['firm.id:1'],
            getRankingInfo: true,
            page: 0,
            hitsPerPage: 1000
          }
        ]
      }
    end
    let(:offices_query) do
      {
        index: :offices,
        value: [
          '',
          {
            aroundLatLng: [51.5139284, -0.1113308],
            facetFilters: ['firm_id:1'],
            getRankingInfo: true,
            page: 0,
            hitsPerPage: 1000
          }
        ]
      }
    end

    it 'builds advisers and offices queries and sends them to Algolia' do
      aggregate_failures do
        VCR.use_cassette(:firm_profile_with_postcode) do
          expect_any_instance_of(described_class).to receive(:search)
            .with(query: advisers_query)
            .exactly(:once)
            .and_call_original

          expect_any_instance_of(described_class).to receive(:search)
            .with(query: offices_query)
            .exactly(:once)
            .and_call_original

          perform_search
        end
      end
    end
  end
end
