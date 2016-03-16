module Geosort
  def self.by_distance(initial_location, objects_with_location)
    objects_with_location.each do |obj|
      distance = Geocoder::Calculations.distance_between(initial_location.to_a, obj.location.to_a)
      obj.distance = distance
    end

    objects_with_location.sort_by(&:distance)
  end
end
