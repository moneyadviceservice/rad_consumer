RSpec.describe FirmsController, type: :controller do
  let!(:firm) { FactoryGirl.create(:firm) }
  let(:search_form_params) { { 'advice_method' => SearchForm::ADVICE_METHOD_FACE_TO_FACE, 'postcode' => 'EC1N 2TD' } }
  let(:offices) { [] }
  let(:advisers) { [] }
  let(:firm_result_1) { double(offices: offices, advisers: advisers) }
  let(:firm_result_2) { double(offices: offices, advisers: advisers) }
  let(:firm_repository) { double }

  describe 'GET #show' do
    before do
      allow(FirmRepository).to receive(:new).and_return(firm_repository)
      allow(firm_repository).to receive(:search).and_return(double(firms: [firm_result_1, firm_result_2]))
      allow_any_instance_of(RadConsumerSession).to receive(:store)
    end

    it 'successfully renders the show page' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        get :show, id: firm.id, locale: :en, search_form: search_form_params
        expect(response).to render_template(:show)
      end
    end

    it "creates a search form with search_form params and the firm's id" do
      VCR.use_cassette(:geocode_search_form_postcode) do
        allow(SearchForm).to receive(:new).and_return(
          double(to_query: {}, coordinates: [51.5, -0.1], face_to_face?: true))
        get :show, id: firm.id, locale: :en, search_form: search_form_params

        expected_params = search_form_params.merge('firm_id' => firm.id.to_s)
        expect(SearchForm).to have_received(:new).with(expected_params)
      end
    end

    it 'assigns the search form' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        search_form = double(SearchForm, to_query: {}, coordinates: [51.5, -0.1], face_to_face?: true)
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

    context 'geosorted offices' do
      let(:offices) { :offices }

      it 'assigns geosorted offices' do
        VCR.use_cassette(:geocode_search_form_postcode) do
          allow(Geosort).to receive(:by_distance).and_return(:geosorted_offices)
          get :show, id: firm.id, locale: :en, search_form: search_form_params

          expect(Geosort).to have_received(:by_distance).with(assigns(:search_form).coordinates, offices)
          expect(assigns(:offices)).to eq(:geosorted_offices)
        end
      end
    end

    context 'geosorted advisers' do
      let(:advisers) { :advisers }

      it 'assigns geosorted advisers' do
        VCR.use_cassette(:geocode_search_form_postcode) do
          allow(Geosort).to receive(:by_distance).and_return(:geosorted_advisers)
          get :show, id: firm.id, locale: :en, search_form: search_form_params

          expect(Geosort).to have_received(:by_distance).with(assigns(:search_form).coordinates, :advisers)
          expect(assigns(:advisers)).to eq(:geosorted_advisers)
        end
      end
    end

    it 'assigns the lat/lon from the postcode supplied in the search form' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        get :show, id: firm.id, locale: :en, search_form: search_form_params
        expect(assigns(:latitude)).to eq(51.5180697)
        expect(assigns(:longitude)).to eq(-0.1085203)
      end
    end

    it 'add requested firm in the recentyl_visited list' do
      VCR.use_cassette(:geocode_search_form_postcode) do
        expected_params = {
          search_form: {
            'advice_method' => 'face_to_face', 'postcode' => 'EC1N 2TD'
          },
          'id' => firm.id.to_s,
          'locale' => 'en',
          'controller' => 'firms',
          'action' => 'show'
        }

        expect_any_instance_of(RadConsumerSession)
          .to receive(:store).with(firm_result_1, expected_params)
        get :show, id: firm.id, locale: :en, search_form: search_form_params
      end
    end
  end
end
