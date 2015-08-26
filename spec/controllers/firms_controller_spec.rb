RSpec.describe FirmsController, type: :controller do
  let!(:firm) { FactoryGirl.create(:firm) }
  let(:search_form_params) { { 'postcode' => 'EC1N 2TD' } }
  let(:firm_result_1) { double }
  let(:firm_result_2) { double }
  let(:firm_repository) { double }

  describe 'GET #show' do
    before do
      allow(FirmRepository).to receive(:new).and_return(firm_repository)
      allow(firm_repository).to receive(:search).and_return(double(firms: [firm_result_1, firm_result_2]))
    end

    it 'successfully renders the show page' do
      get :show, id: firm.id, locale: :en, search_form: search_form_params
      expect(response).to render_template(:show)
    end

    it "creates a search form with search_form params and the firm's id" do
      allow(SearchForm).to receive(:new).and_return(double(to_query: {}))
      get :show, id: firm.id, locale: :en, search_form: search_form_params

      expected_params = search_form_params.merge('firm_id' => firm.id.to_s)
      expect(SearchForm).to have_received(:new).with(expected_params)
    end

    it 'assigns the first firm result to the view' do
      get :show, id: firm.id, locale: :en, search_form: search_form_params
      expect(assigns(:firm)).to eq(firm_result_1)
    end
  end
end
