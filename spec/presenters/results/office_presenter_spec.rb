RSpec.describe Results::OfficePresenter do
  let(:object) do
    {
      _geoloc: { lat: 51.5180967, lng: -0.1102626 },
      address_line_one: 'Holborn 120',
      address_line_two: '',
      address_town: 'London',
      address_county: nil,
      address_postcode: 'EC1N 2TD',
      email_address: nil,
      telephone_number: nil,
      disabled_access: false,
      website: nil
    }.with_indifferent_access
  end
  subject(:presenter) { described_class.new(object) }

  describe 'directly mapped fields' do
    %i[
      address_line_one
      address_line_two
      address_town
      address_county
      address_postcode
      email_address
      telephone_number
      disabled_access
      website
    ].each do |field|
      it { expect(presenter).to respond_to(field) }
      it { expect(presenter.public_send(field)).to eq(object[field]) }
    end
  end

  describe '#location' do
    it 'returns a Location object initialised with geoloc data' do
      expect(presenter.location).to eq(Location.new(*object['_geoloc'].values))
    end
  end
end
