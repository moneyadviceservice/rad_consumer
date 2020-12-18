RSpec.describe Helpers::Algolia::Geolocation, type: :helper do
  describe '.fetch_in_consumer_range_firm_ids' do
    let(:query) do
      {
        index: :advisers,
        value: [
          '',
          { anything: :really }
        ]
      }
    end
    let(:response) do
      {
        hits: [
          {
            travel_distance: 10, # miles
            firm: { id: 1 },
            _rankingInfo: {
              matchedGeoLocation: {
                distance: 10 / 0.00062137 # miles over meters
              }
            }
          },
          {
            travel_distance: 10,
            firm: { id: 1 },
            _rankingInfo: {
              matchedGeoLocation: {
                distance: 15 / 0.00062137
              }
            }
          },
          {
            travel_distance: 10,
            firm: { id: 2 },
            _rankingInfo: {
              matchedGeoLocation: {
                distance: 20 / 0.00062137
              }
            }
          },
          {
            travel_distance: 25,
            firm: { id: 2 },
            _rankingInfo: {
              matchedGeoLocation: {
                distance: 30 / 0.00062137
              }
            }
          },
          {
            travel_distance: 100,
            firm: { id: 3 },
            _rankingInfo: {
              matchedGeoLocation: {
                distance: 50 / 0.00062137
              }
            }
          }
        ],
        nbPages: 1
      }.with_indifferent_access
    end

    before do
      allow_any_instance_of(::Algolia::Index).to receive(:search)
        .and_return(response)
    end

    it 'returns firm ids of advisers who can travel the matched distance' do
      ids = helper.fetch_in_consumer_range_firm_ids(query: query)
      expect(ids).to eq([1, 3])
    end
  end
end
