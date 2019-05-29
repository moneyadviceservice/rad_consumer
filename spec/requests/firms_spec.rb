RSpec.describe 'Firms' do
  before { VCR.insert_cassette(cassette_name) }
  after { VCR.eject_cassette }

  context 'without postcode' do
    let(:cassette_name) { :firm_profile_without_postcode }

    it 'retrieves a firm', :aggregate_failures do
      get '/en/firms/1'

      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)

      expect(response.body).to include('Test Firm Central London')
    end
  end

  context 'with postcode' do
    let(:cassette_name) { :firm_profile_with_postcode }

    it 'retrieves a firm with the nearest adviser', :aggregate_failures do
      get '/en/firms/1', params: { postcode: 'EC4A 2AH' }

      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)

      expect(response.body).to include('Test Firm Central London')
      expect(response.body).to match(/has an adviser\s+\d+.\d+ miles away/)
    end
  end
end
