RSpec.describe 'Search' do
  before { VCR.insert_cassette(cassette_name) }
  after { VCR.eject_cassette }

  context 'in person' do
    context 'with valid postcode' do
      let(:cassette_name) { :search_in_person_valid_geocode }
      let(:params) do
        {
          search_form: {
            advice_method: 'face_to_face',
            postcode: 'EC4A 2AH'
          }
        }
      end

      it 'returns firms with in person advisers', :aggregate_failures do
        get '/en/search', params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(
          'Test Firm Central London',
          'Test Firm East London',
          'Test Firm Brighton'
        )
        expect(response.body.scan(/has an adviser\s+\d+.\d+ miles away/).size)
          .to eq(3)
      end
    end

    context 'with invalid postcode' do
      let(:cassette_name) { :search_in_person_failed_geocode }
      let(:params) do
        {
          search_form: {
            advice_method: 'face_to_face',
            postcode: 'EX1 WRNG'
          }
        }
      end

      it 'returns an error message', :aggregate_failures do
        get '/en/search', params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(
          'Please double-check for the following errors',
          'Postcode is incorrect'
        )
      end
    end
  end

  context 'phone or online' do
    let(:cassette_name) { :search_phone_or_online }
    let(:params) do
      {
        search_form: {
          advice_method: 'phone_or_online'
        }
      }
    end

    it 'returns firms with exclusively phone or online advisers' do
      aggregate_failures do
        get '/en/search', params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(
          'Test Firm Remote 1',
          'Test Firm Remote 2',
          'Test Firm Remote 3'
        )
      end
    end
  end

  context 'search firm by name' do
    let(:cassette_name) { :search_firm_by_name }
    let(:params) do
      {
        search_form: {
          advice_method: 'firm_name_search',
          firm_name: 'london'
        }
      }
    end

    it 'returns firms matching the provided name', :aggregate_failures do
      get '/en/search', params: params

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        'Test Firm Central London',
        'Test Firm East London'
      )
      expect(response.body).not_to include(
        'Test Firm Brighton',
        'Test Firm Remote 1',
        'Test Firm Remote 2',
        'Test Firm Remote 3'
      )
    end
  end
end
