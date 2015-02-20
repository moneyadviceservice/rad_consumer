class Geocode
  def self.call(postcode)
    normalised_postcode = postcode.delete(' ')

    Geocoder.coordinates("#{normalised_postcode}, United Kingdom")
  end
end
