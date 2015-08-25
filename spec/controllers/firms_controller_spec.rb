RSpec.describe FirmsController, type: :controller do
  let!(:firm) { FactoryGirl.create(:firm) }

  describe 'GET #show' do
    it 'successfully renders the show page' do
      get :show, id: firm.id, locale: :en
      expect(response).to render_template(:show)
    end
  end
end
