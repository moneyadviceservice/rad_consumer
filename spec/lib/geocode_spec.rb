RSpec.describe Geocode, '#call' do
  it 'ensures the postcode is scoped to the United Kingdom' do
    expect(Geocoder).to receive(:coordinates).with('RG1 1GG, United Kingdom')

    Geocode.call('RG1 1GG')
  end

  it 'returns the lat/long pair', :aggreate_failures do
    VCR.use_cassette(:geocoded_postcode) do
      latitude, longitude = Geocode.call('RG11GG')

      expect(latitude).to eql(51.4607254)
      expect(longitude).to eql(-0.9747992000000001)
    end
  end
end
