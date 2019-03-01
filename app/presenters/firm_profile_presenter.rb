class FirmProfilePresenter
  include ApplicationHelper

  def initialize(json)
    @json = json
  end

  def advisers_hits
    json[:advisers]['hits']
  end

  def offices_hits
    json[:offices]['hits']
  end

  def firm
    return unless advisers_hits.first&.fetch('firm')

    hit = advisers_hits.first['firm']
    FirmPresenter.new(hit).tap do |firm|
      firm.offices = offices
      firm.advisers = advisers
      firm.closest_adviser_distance = closest_adviser_distance
    end
  end

  private

  attr_reader :json

  def offices
    offices_hits.map do |hit|
      OfficePresenter.new(hit)
    end
  end

  def advisers
    advisers_hits.map do |hit|
      AdviserPresenter.new(hit.except('firm')).tap do |adviser|
        adviser.distance = adviser_distance(hit)
      end
    end
  end

  def closest_adviser_distance
    adviser_distance(advisers_hits.first)
  end

  def adviser_distance(hit)
    return unless hit['_rankingInfo']

    distance_in_meters = hit['_rankingInfo']['geoDistance']
    meters_to_miles(distance_in_meters)
  end
end
