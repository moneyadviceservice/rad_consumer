RSpec.describe SearchController, type: :controller do
  describe 'index' do
    let(:search_form_params) do
      {
        'advice_method' => SearchForm::ADVICE_METHOD_FACE_TO_FACE,
        'postcode' => 'EC1N 2TD'
      }
    end
    let(:firm_repository) { double }
    let(:search_result) { double }
    let(:total_pages) { 10 }
    before(:each) do
      allow(FirmRepository).to receive(:new).and_return(firm_repository)
      allow(firm_repository).to receive(:search).and_return(search_result)
      allow(search_result).to receive(:total_pages).and_return(total_pages)
    end

    describe 'search is valid' do
      it 'renders search results' do
        VCR.use_cassette(:geocode_search_form_postcode) do
          get :index, locale: :en, page: 1, search_form: search_form_params
          expect(response).to render_template('search/index')
        end
      end
    end

    describe 'form is not valid' do
      let(:search_form_params) do
        {
          'advice_method' => SearchForm::ADVICE_METHOD_FACE_TO_FACE,
          'postcode' => 'Buckingham Palace'
        }
      end

      it 'renders searchable_view' do
        VCR.use_cassette(:geocode_search_form_postcode) do
          get :index, locale: :en, page: 1, search_form: search_form_params
          expect(response).to render_template('landing_page/show')
        end
      end
    end

    describe 'redirect to 404 if page number more than total pages' do
      let(:total_pages) { 0 }

      it 'redirects to 404' do
        VCR.use_cassette(:geocode_search_form_postcode) do
          get :index, locale: :en, page: 1, search_form: search_form_params
          expect(response.status).to eq(404)
          expect(response).to render_template(file: '404.html')
        end
      end
    end
  end
end
