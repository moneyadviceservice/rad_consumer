class Geocode
  def self.call(postcode)
    normalised_postcode = postcode.upcase.delete(' ')

    Geocoder.coordinates("#{normalised_postcode}, United Kingdom")
  end
end
