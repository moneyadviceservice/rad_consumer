module Helpers::Algolia
  module Geolocation
    include Index

    def fetch_in_consumer_range_firm_ids(query:)
      browse(query:)
        .select { |hit| in_range?(hit) }
        .map { |hit| hit['firm']['id'] }
    end

    private

    def in_range?(hit)
      distance_in_meters = hit['_rankingInfo']['matchedGeoLocation']['distance']
      distance_in_miles = distance_in_meters * 0.00062137

      hit['travel_distance'] >= distance_in_miles
    end
  end
end
