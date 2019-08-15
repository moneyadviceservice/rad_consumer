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
  let(:office) { Results::OfficePresenter.new(data) }
  let(:firm_data) do
    {
      'offices' => [office],
      'advisers' => [],
      'website_address' => 'http://www.firmsite.com'
    }
  end
  let(:firm) { Results::FirmPresenter.new(firm_data) }

  describe '#display_telephone' do
    let(:firm_data) { { 'telephone_number' => '333 333333333' } }

    before do
      allow(helper).to receive(:params).and_return(params)
    end

    context 'when searching by postcode' do
      let(:params) { { postcode: 'NW8' } }

      before do
        allow(firm).to receive(:offices).and_return(offices)
      end

      context 'when firm has offices' do
        let(:offices) { [double(telephone_number: '0118 9021633')] }

        it 'returns telephone from the first office (nearest office)' do
          expect(display_telephone(firm)).to eq('0118 9021633')
        end
      end

      context 'when firm does not have offices' do
        let(:offices) { [] }

        it 'returns telephone from the firm' do
          expect(display_telephone(firm)).to eq('333 333333333')
        end
      end
    end

    context 'when not searching by postcode' do
      let(:params) { { postcode: nil } }

      it 'returns telephone from the firm' do
        expect(display_telephone(firm)).to eq('333 333333333')
      end
    end
  end

  describe '#office_address' do
    it 'outputs a ", " concatenated string of the address' do
      expected = 'c/o Postman Pat, Forge Cottage, Greendale, Cumbria, LA8 9BE'
      expect(office_address(office)).to eq(expected)
    end
  end

  describe '#display_website' do
    context 'when the office has its own website address' do
      it 'returns the office website' do
        expected = 'http://www.postman.com'
        expect(display_website(office, firm)).to eq(expected)
      end
    end

    context 'when the office no website address' do
      let(:website) { nil }

      it 'returns the firm\'s website' do
        expected = 'http://www.firmsite.com'
        expect(display_website(office, firm)).to eq(expected)
      end
    end
  end

  describe '#website_url' do
    let(:website) { 'www.no-scheme.com' }

    it 'ensures the return of display_website has a scheme' do
      expected = 'https://www.no-scheme.com'
      expect(website_url(office, firm)).to eq(expected)
    end

    context 'when the scheme is present' do
      let(:website) { 'http://www.with-scheme.com' }

      it 'does not change its value' do
        expected = 'http://www.with-scheme.com'
        expect(website_url(office, firm)).to eq(expected)
      end
    end

    context 'when the url has extra spaces' do
      let(:website) { 'http://www.with-scheme.com ' }

      it 'strips the return before calling URI' do
        expected = 'http://www.with-scheme.com'
        expect(website_url(office, firm)).to eq(expected)
      end
    end

    context 'when the website is not present' do
      let(:website) { nil }

      let(:firm_data) do
        {
          '_source' => {
            'offices' => [office],
            'advisers' => [],
            'website_address' => ''
          }
        }
      end

      it 'returns' do
        expect(website_url(office, firm)).to eq(nil)
      end
    end
  end
end
