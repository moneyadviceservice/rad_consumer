RSpec.describe FirmsController, type: :controller do
  around do |example|
    with_elastic_search! do
      with_fresh_index! do
        example.run
      end
    end
  end

  let!(:firm) { FactoryGirl.create(:firm) }

  describe 'GET #show' do
    before { index_all!; get :show, id: firm.id, locale: :en }

    specify { expect(response).to have_http_status(200) }

    it 'assigns a firm result' do
      expect(assigns(:firm).id).to eq firm.id
    end
  end
end
