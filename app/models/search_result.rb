class SearchResult
  include Paginateable

  attr_reader :current_page

  def initialize(response, page: 1)
    @json = response
    @current_page = page
  end

  def firms
    return [] if json.blank?

    @firms ||= hits.map do |hit|
      hit['firm']['closest_adviser'] = closest_adviser(hit)
      SearchResults::FirmPresenter.new(hit['firm'])
    end
  end

  def closest_adviser(hit)
    return unless hit['_rankingInfo']

    hit['_rankingInfo']['matchedGeoLocation']['distance'] * 0.00062137 # miles
  end

  private

  attr_reader :json

  def hits
    json['hits']
  end
end
