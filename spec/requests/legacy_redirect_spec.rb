RSpec.describe 'Legacy redirects from non-embedded TLDs' do
  before do
    host! 'directory.moneyadviceservice.org.uk'
  end

  context 'for the naked locale' do
    it 'redirects to the EN default' do
      get 'http://directory.moneyadviceservice.org.uk'

      expect(response).to redirect_to(ENGLISH_EMBED_URL)
    end
  end

  context 'for the EN locale' do
    it 'redirects to the EN default' do
      # without further path segments
      get 'http://directory.moneyadviceservice.org.uk/en'
      expect(response).to redirect_to(ENGLISH_EMBED_URL)

      # with further path segments
      get 'http://directory.moneyadviceservice.org.uk/en/blah/blah/meh'
      expect(response).to redirect_to(ENGLISH_EMBED_URL)
    end
  end

  context 'for the CY locale' do
    it 'redirects to the CY default' do
      # without further path segments
      get 'http://directory.moneyadviceservice.org.uk/cy'
      expect(response).to redirect_to(WELSH_EMBED_URL)

      # with further path segments
      get 'http://directory.moneyadviceservice.org.uk/cy/hey/hi/'
      expect(response).to redirect_to(WELSH_EMBED_URL)
    end
  end
end
