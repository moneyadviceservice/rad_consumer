require 'spec_helper'

RSpec.describe OfficeHelper, type: :helper do
  let(:data) do
    {
      '_id'              => 123,
      'address_line_one' => 'c/o Postman Pat',
      'address_line_two' => 'Forge Cottage',
      'address_town'     => 'Greendale',
      'address_county'   => 'Cumbria',
      'address_postcode' => 'LA8 9BE',
      'email_address'    => 'postie@example.com',
      'telephone_number' => '5555 555 5555',
      'disabled_access'  => true,
      'location' => { 'lat' => 51.5180697, 'lon' => -0.1085203 }
    }
  end
  let(:office_result) { OfficeResult.new(data) }

  describe '#office_address' do
    it 'outputs a ", " concatenated string of the address' do
      expected = 'c/o Postman Pat, Forge Cottage, Greendale, Cumbria, LA8 9BE'
      expect(office_address(office_result)).to eq(expected)
    end
  end
end
