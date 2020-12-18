RSpec.describe SessionJar do
  let(:session_jar) { described_class.new(session) }

  describe '.recently_visited_firms' do
    context 'when there are no previously visited firms' do
      let(:session) { { recently_visited_firms: [] } }

      it { expect(session_jar.recently_visited_firms).to be_blank }
    end

    context 'when previously visited firms are present' do
      let(:session) { { recently_visited_firms: firm_params } }
      let(:firm_params) do
        [
          {
            'id': 1,
            'name': 'Advisers Ltd 1',
            'closest_adviser_distance': 146.92107239,
            'face_to_face?': true,
            'profile_path': {
              'en': 'en/firms/381',
              'cy': 'cy/firms/381'
            }
          },
          {
            'id': 2,
            'name': 'Advisers Ltd 2',
            'closest_adviser_distance': 136.13408919,
            'face_to_face?': true,
            'profile_path': {
              'en': 'en/firms/1550',
              'cy': 'cy/firms/1550'
            }
          },
          {
            'id': 3,
            'name': 'Advisers Ltd 3',
            'closest_adviser_distance': 0.05468056,
            'face_to_face?': true,
            'profile_path': {
              'en': 'en/firms/3?postcode=EC1N+2TD',
              'cy': 'cy/firms/3?postcode=EC1N+2TD'
            }
          }
        ]
      end

      it 'returns them' do
        expect(session_jar.recently_visited_firms)
          .to eq(firm_params)
      end
    end
  end

  describe '.last_search_results' do
    context 'when there is no last search' do
      let(:session) { { last_search: {} } }

      it { expect(session_jar.recently_visited_firms).to be_blank }
    end

    context 'when last search is present' do
      let(:session) { { last_search: search_params } }
      let(:search_params) do
        {
          params: {
            investment_sizes: 'any',
            advice_method: 'firm_name_search',
            postcode: '',
            firm_name: 'aviser',
            random_search_seed: 7,
            retirement_income_products: 0,
            pension_transfer: 0,
            options_when_paying_for_care: 0,
            equity_release: 0,
            inheritance_tax_planning: 0,
            wills_and_probate: 0,
            ethical_investing_flag: 0,
            sharia_investing_flag: 0,
            non_uk_residents_flag: 0,
            qualification_or_accreditation: '',
            language: '',
            setting_up_workplace_pension_flag: 0,
            existing_workplace_pension_flag: 0,
            advice_for_employees_flag: 0,
            page: 1
          }
        }
      end

      it 'returns it' do
        expect(session_jar.last_search).to eq(search_params)
      end
    end
  end

  describe '.last_search_url' do
    context 'when there is no last search' do
      let(:session) { {} }

      %i[en cy].each do |locale|
        it { expect(session_jar.last_search_url(locale)).to be_nil }
      end
    end

    context 'when last search is present' do
      let(:session) { { last_search: search_params } }
      let(:search_params) do
        {
          params: {
            investment_sizes: 'any',
            advice_method: 'firm_name_search',
            postcode: '',
            firm_name: 'adviser',
            random_search_seed: 7,
            retirement_income_products: 0,
            pension_transfer: 0,
            options_when_paying_for_care: 0,
            equity_release: 0,
            inheritance_tax_planning: 0,
            wills_and_probate: 0,
            ethical_investing_flag: 0,
            sharia_investing_flag: 0,
            non_uk_residents_flag: 0,
            qualification_or_accreditation: '',
            language: '',
            setting_up_workplace_pension_flag: 0,
            existing_workplace_pension_flag: 0,
            advice_for_employees_flag: 0,
            page: 1
          }
        }
      end

      %i[en cy].each do |locale|
        it "returns the relative search path for #{locale} translation" do
          expected_url = search_path(
            page: search_params[:params][:page],
            search_form: search_params[:params].except(:page),
            locale: locale
          )
          expect(session_jar.last_search_url(locale)).to eq(expected_url)
        end
      end
    end
  end

  describe '.last_search_randomised_firm_ids' do
    context 'when there is no last search' do
      let(:session) { {} }

      it { expect(session_jar.last_search_randomised_firm_ids).to be_blank }
    end

    context 'when last search is present' do
      let(:session) { { last_search: search_params } }
      let(:search_params) do
        {
          randomised_firm_ids: [3, 199, 42]
        }
      end

      it 'returns them' do
        expect(session_jar.last_search_randomised_firm_ids)
          .to eq(search_params[:randomised_firm_ids])
      end
    end
  end

  describe '.already_stored_search?' do
    subject(:already_stored_search?) do
      session_jar.already_stored_search?(
        current_params,
        page_sensitive: page_sensitive
      )
    end
    let(:current_params) { {} }
    let(:page_sensitive) { true }

    context 'when there is no last search' do
      let(:session) { {} }

      it { expect(already_stored_search?).to eq(false) }
    end

    context 'when there is a last search but with different params' do
      let(:session) { { last_search: search_params } }
      let(:search_params) do
        {
          params: {
            investment_sizes: 'any',
            advice_method: 'firm_name_search',
            postcode: '',
            firm_name: 'adviser',
            random_search_seed: 7,
            retirement_income_products: 0,
            pension_transfer: 0,
            options_when_paying_for_care: 0,
            equity_release: 0,
            inheritance_tax_planning: 0,
            wills_and_probate: 0,
            ethical_investing_flag: 0,
            sharia_investing_flag: 0,
            non_uk_residents_flag: 0,
            qualification_or_accreditation: '',
            language: '',
            setting_up_workplace_pension_flag: 0,
            existing_workplace_pension_flag: 0,
            advice_for_employees_flag: 0,
            page: 1
          }
        }
      end

      it { expect(already_stored_search?).to eq(false) }
    end

    context 'when there is a last search with the same params' do
      let(:session) { { last_search: search_params } }
      let(:search_params) do
        {
          params: {
            investment_sizes: 'any',
            advice_method: 'firm_name_search',
            postcode: '',
            firm_name: 'adviser',
            random_search_seed: 7,
            retirement_income_products: 0,
            pension_transfer: 0,
            options_when_paying_for_care: 0,
            equity_release: 0,
            inheritance_tax_planning: 0,
            wills_and_probate: 0,
            ethical_investing_flag: 0,
            sharia_investing_flag: 0,
            non_uk_residents_flag: 0,
            qualification_or_accreditation: '',
            language: '',
            setting_up_workplace_pension_flag: 0,
            existing_workplace_pension_flag: 0,
            advice_for_employees_flag: 0,
            page: 1
          }
        }
      end
      let(:current_params) { search_params[:params] }

      it { expect(already_stored_search?).to eq(true) }
    end

    context 'when page sensitive param is set to true' do
      let(:page_sensitive) { true }
      let(:session) { { last_search: search_params } }
      let(:search_params) do
        {
          params: {
            investment_sizes: 'any',
            advice_method: 'firm_name_search',
            postcode: '',
            firm_name: 'adviser',
            random_search_seed: 7,
            retirement_income_products: 0,
            pension_transfer: 0,
            options_when_paying_for_care: 0,
            equity_release: 0,
            inheritance_tax_planning: 0,
            wills_and_probate: 0,
            ethical_investing_flag: 0,
            sharia_investing_flag: 0,
            non_uk_residents_flag: 0,
            qualification_or_accreditation: '',
            language: '',
            setting_up_workplace_pension_flag: 0,
            existing_workplace_pension_flag: 0,
            advice_for_employees_flag: 0,
            page: 1
          }
        }
      end
      let(:current_params) { search_params[:params].merge(page: 10) }

      it 'returns false despite the page being different' do
        expect(already_stored_search?).to eq(false)
      end
    end

    context 'when page sensitive param is set to false' do
      let(:page_sensitive) { false }
      let(:session) { { last_search: search_params } }
      let(:search_params) do
        {
          params: {
            investment_sizes: 'any',
            advice_method: 'firm_name_search',
            postcode: '',
            firm_name: 'adviser',
            random_search_seed: 7,
            retirement_income_products: 0,
            pension_transfer: 0,
            options_when_paying_for_care: 0,
            equity_release: 0,
            inheritance_tax_planning: 0,
            wills_and_probate: 0,
            ethical_investing_flag: 0,
            sharia_investing_flag: 0,
            non_uk_residents_flag: 0,
            qualification_or_accreditation: '',
            language: '',
            setting_up_workplace_pension_flag: 0,
            existing_workplace_pension_flag: 0,
            advice_for_employees_flag: 0,
            page: 1
          }
        }
      end
      let(:current_params) { search_params[:params].merge(page: 10) }

      it 'returns true despite the page being different' do
        expect(already_stored_search?).to eq(true)
      end
    end
  end

  describe '.update_most_recent_search' do
    subject(:update_most_recent_search) do
      session_jar.update_most_recent_search(
        search_params,
        randomised_firm_ids
      )
    end
    let(:randomised_firm_ids) { [3, 1, 100] }
    let(:search_params) do
      {
        investment_sizes: 'any',
        advice_method: 'firm_name_search',
        postcode: '',
        firm_name: 'adviser',
        random_search_seed: 7,
        retirement_income_products: 0,
        pension_transfer: 0,
        options_when_paying_for_care: 0,
        equity_release: 0,
        inheritance_tax_planning: 0,
        wills_and_probate: 0,
        ethical_investing_flag: 0,
        sharia_investing_flag: 0,
        non_uk_residents_flag: 0,
        qualification_or_accreditation: '',
        language: '',
        setting_up_workplace_pension_flag: 0,
        existing_workplace_pension_flag: 0,
        advice_for_employees_flag: 0,
        page: 1
      }
    end

    context 'when there is no last search' do
      let(:session) { {} }

      it 'saves the current search and randomised ids' do
        update_most_recent_search
        expect(session_jar.last_search).to eq(
          params: search_params,
          randomised_firm_ids: randomised_firm_ids
        )
      end
    end

    context 'when last search is present but with different params' do
      let(:session) do
        {
          last_search: {
            params: search_params.merge(page: 100),
            randomised_firm_ids: []
          }
        }
      end

      it 'saves the current search and randomised ids' do
        update_most_recent_search
        expect(session_jar.last_search).to eq(
          params: search_params,
          randomised_firm_ids: randomised_firm_ids
        )
      end
    end
  end

  describe '.update_recently_visited_firms' do
    def firm_params(id)
      {
        'id': id,
        'name': "Advisers Ltd #{id}",
        'closest_adviser_distance': 146.92107239,
        'face_to_face?': false,
        'profile_path': {
          'en': "/en/firms/#{id}",
          'cy': "/cy/firms/#{id}"
        }
      }
    end

    context 'when adding previously visited firms' do
      def add_firm(id)
        firm_params = firm_params(id)
        firm_result = instance_double(
          Results::FirmPresenter,
          id: firm_params[:id],
          name: firm_params[:name],
          closest_adviser_distance: firm_params[:closest_adviser_distance],
          in_person_advice_methods: []
        )

        params = { id: firm_params[:id] }
        session_jar.update_recently_visited_firms(firm_result, params)
      end

      let(:session) { {} }

      before do
        add_firm(1)
        add_firm(2)
        add_firm(3)
        2.times { add_firm(4) }
      end

      it 'saves the last 3 visited firms without adding duplicates' do
        expect(session_jar.recently_visited_firms)
          .to eq([firm_params(4), firm_params(3), firm_params(2)])
      end
    end
  end
end
