module Geosort
  def self.by_distance(initial_location, objects_with_location)
    obj_distance_pairs = {}

    objects_with_location.each do |obj|
      distance = Geocoder::Calculations.distance_between(initial_location.to_a, obj.location.to_a)
      obj_distance_pairs[obj] = distance
    end

    obj_distance_pairs
      .sort_by { |_key, value| value }
      .flatten
      .reject { |x| x.is_a? Float }
  end
end
