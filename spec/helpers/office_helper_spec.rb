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
      'website'          => website,
      'location' => { 'lat' => 51.5180697, 'lon' => -0.1085203 }
    }
  end

  let(:website) { 'http://www.postman.com' }
  let(:office_result) { OfficeResult.new(data) }
  let(:firm_data) { firm_data }
  let(:firm_result) { FirmResult.new(firm_data) }

  describe '#office_address' do
    it 'outputs a ", " concatenated string of the address' do
      expected = 'c/o Postman Pat, Forge Cottage, Greendale, Cumbria, LA8 9BE'
      expect(office_address(office_result)).to eq(expected)
    end
  end

  describe '#display_website' do
    context 'when the office has its own website address' do
      it 'returns the office website' do
        expected = 'http://www.postman.com'
        expect(display_website(office_result, firm_result)).to eq(expected)
      end
    end

    context 'when the office no website address' do
      let(:website) { nil }

      it 'returns the firm\'s website' do
        expected = 'http://www.firmsite.com'
        expect(display_website(office_result, firm_result)).to eq(expected)
      end
    end
  end

  def firm_data
    {
      '_source' => {
        'offices' => [office_result],
        'advisers' => [],
        'website_address' => 'http://www.firmsite.com'
      }
    }
  end
end
