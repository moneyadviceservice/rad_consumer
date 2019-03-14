RSpec.describe Results::AdviserPresenter do
  let(:object) do
    {
      _geoloc: { lat: 51.5180967, lng: -0.1102626 },
      name: 'adviser',
      postcode: 'EC1N 2TD',
      range: 5,
      qualification_ids: [1, 2],
      accreditation_ids: [3],
      firm: nil
    }.with_indifferent_access
  end
  subject(:presenter) { described_class.new(object) }

  describe 'directly mapped fields' do
    %i[
      name
      postcode
      range
      qualification_ids
      accreditation_ids
      firm
    ].each do |field|
      it { expect(presenter).to respond_to(field) }
      it { expect(presenter.public_send(field)).to eq(object[field]) }
    end
  end

  describe 'other fields' do
    %i[distance].each do |field|
      it { expect(presenter).to respond_to(field) }
      it { expect(presenter).to respond_to(:"#{field}=") }
      it { expect(presenter.public_send(field)).to eq(object[field]) }
    end
  end

  describe '#location' do
    it 'returns a Location object initialised with geoloc data' do
      expect(presenter.location).to eq(Location.new(*object['_geoloc'].values))
    end
  end
end
