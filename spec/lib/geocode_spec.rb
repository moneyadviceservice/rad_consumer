RSpec.describe Geocode, '#call' do
  it 'ensures the postcode is scoped to the United Kingdom' do
    expect(Geocoder).to receive(:coordinates).with('RG1 1GG, United Kingdom')

    Geocode.call('RG1 1GG')
  end

  it 'returns the lat/long pair' do
    VCR.use_cassette(:rg11gg) do
      latitude, longitude = Geocode.call('RG11GG')

      expect(latitude).to eql(51.45326439999999)
      expect(longitude).to eql(-0.9634222000000001)
    end
  end
end
