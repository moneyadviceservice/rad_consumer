class Geocode
  def self.call(postcode)
    Geocoder.coordinates("#{postcode}, United Kingdom")
  end
end
