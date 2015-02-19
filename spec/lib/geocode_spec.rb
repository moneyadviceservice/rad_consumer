RSpec.describe Geocode do
  it 'normalises the postcode' do
    expect(Geocoder).to receive(:coordinates).with('RG11GG, United Kingdom')

    Geocode.call('rg1 1gg')
  end

  it 'returns the lat/long pair' do
    VCR.use_cassette(:rg11gg) do
      latitude, longitude = Geocode.call('RG11GG')

      expect(latitude).to  be
      expect(longitude).to be
    end
  end
end
