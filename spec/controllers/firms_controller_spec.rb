RSpec.describe FirmsController, type: :controller do
  let!(:firm) { FactoryGirl.create(:firm) }
  let(:search_form_params) { { 'advice_method' => SearchForm::ADVICE_METHOD_FACE_TO_FACE, 'postcode' => 'EC1N 2TD' } }
  let(:firm_result_1) { double }
  let(:firm_result_2) { double }
  let(:firm_repository) { double }

  describe 'GET #show' do
    before do
      allow(FirmRepository).to receive(:new).and_return(firm_repository)
      allow(firm_repository).to receive(:search).and_return(double(firms: [firm_result_1, firm_result_2]))
    end

    it 'successfully renders the show page' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        get :show, id: firm.id, locale: :en, search_form: search_form_params
        expect(response).to render_template(:show)
      end
    end

    it "creates a search form with search_form params and the firm's id" do
      VCR.use_cassette(:geocode_search_form_postcode) do
        allow(SearchForm).to receive(:new).and_return(double(to_query: {}, coordinates: [51.5, -0.1]))
        get :show, id: firm.id, locale: :en, search_form: search_form_params

        expected_params = search_form_params.merge('firm_id' => firm.id.to_s)
        expect(SearchForm).to have_received(:new).with(expected_params)
      end
    end

    it 'assigns the search form' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        search_form = double(SearchForm, to_query: {}, coordinates: [51.5, -0.1])
        allow(SearchForm).to receive(:new).and_return(search_form)

        get :show, id: firm.id, locale: :en, search_form: search_form_params
        expect(assigns(:search_form)).to eq(search_form)
      end
    end

    it 'assigns the first firm result to the view' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        get :show, id: firm.id, locale: :en, search_form: search_form_params
        expect(assigns(:firm)).to eq(firm_result_1)
      end
    end

    it 'assigns the lat/lon from the postcode supplied in the search form' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        get :show, id: firm.id, locale: :en, search_form: search_form_params
        expect(assigns(:latitude)).to eq(51.5180697)
        expect(assigns(:longitude)).to eq(-0.1085203)
      end
    end
  end
end
