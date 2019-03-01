class SearchResultsPresenter
  include ApplicationHelper
  include Pagination

  attr_reader :current_page

  def initialize(json, page:)
    @json = json
    @current_page = page
  end

  def hits
    json['hits']
  end

  def total_records
    json['nbHits']
  end

  def firms
    @firms ||= hits.map do |hit|
      FirmPresenter.new(hit['firm']).tap do |firm|
        firm.closest_adviser_distance = closest_adviser_distance(hit)
      end
    end
  end

  private

  attr_reader :json

  def closest_adviser_distance(hit)
    return unless hit['_rankingInfo']

    distance_in_meters = hit['_rankingInfo']['matchedGeoLocation']['distance']
    meters_to_miles(distance_in_meters)
  end
end
