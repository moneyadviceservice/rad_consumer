Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [{ latitude: 51.5180697, longitude: -0.1085203 }]
)

