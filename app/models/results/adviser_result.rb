class AdviserResult
  attr_reader :id, :name, :postcode, :range, :location, :qualification_ids, :accreditation_ids, :firm
  attr_accessor :distance

  def initialize(object)
    @id       = object['ObjectID']
    @name     = object['name']
    @postcode = object['postcode']
    # @range    = object['range'] TODO: add back, intersect with aroundRadius
    @location = Location.new(object['_geoloc']['lat'], object['_geoloc']['lng'])
    @qualification_ids = object['qualification_ids']
    @accreditation_ids = object['accreditation_ids']
    @firm = FirmResult.new(object['firm'], closest_adviser: object)
  end
end
