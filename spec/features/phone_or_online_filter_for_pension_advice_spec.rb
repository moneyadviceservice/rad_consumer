RSpec.feature 'Consumer requires help with their pension over the phone or online' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let(:latitude) { rand(51.428473..55.856191) }
  let(:longitude) { rand(-4.247082..-0.943616) }

  scenario 'Filter for general pension pot advice' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_types
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_see_the_default_option_is_i_dont_know_or_wish_to_say
      when_i_submit_the_phone_or_online_advice_search
      then_i_am_shown_firms_that_can_advise_on_pension_pots
    end
  end

  scenario 'Filter for advice on a pension pot size' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_types
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_select_a_pot_size_band_from_the_available_options
      when_i_submit_the_phone_or_online_advice_search
      then_i_am_shown_firms_that_can_advise_on_my_pension_pot_size
    end
  end

  scenario 'Filter for advice on pension pot transfers' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_types
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_select_a_pot_size_band_from_the_available_options
      and_i_indicate_that_i_would_like_to_transfer_my_pension
      when_i_submit_the_phone_or_online_advice_search
      then_i_am_shown_firms_that_can_assist_with_pension_transfers
    end
  end

  def and_i_am_on_the_landing_page
    landing_page.load
  end

  def given_firms_with_advisers_were_previously_indexed
    @investment_sizes = create_list(:investment_size, 5)

    other_advice_methods = [
      create(:other_advice_method, name: 'Advice by telephone', order: 1),
      create(:other_advice_method, name: 'Advice online (e.g. by video call / conference / email)', order: 2)
    ]

    with_fresh_index! do
      @small_pot_size_firm = create(:firm_with_no_business_split,
        retirement_income_products_percent: 90,
        other_percent: 10,
        investment_sizes: @investment_sizes.values_at(0, 1),
        other_advice_methods: other_advice_methods
      )

      create(:adviser, firm: @small_pot_size_firm, latitude: latitude, longitude: longitude)

      @medium_pot_size_firm = create(:firm_with_no_business_split,
        retirement_income_products_percent: 10,
        other_percent: 90,
        investment_sizes: @investment_sizes.values_at(2, 3),
        other_advice_methods: other_advice_methods
      )

      create(:adviser, firm: @medium_pot_size_firm, latitude: latitude, longitude: longitude)

      @pension_transfer_firm = create(:firm_with_no_business_split,
        retirement_income_products_percent: 50,
        pension_transfer_percent: 50,
        investment_sizes: @investment_sizes,
        other_advice_methods: other_advice_methods
      )

      create(:adviser, firm: @pension_transfer_firm, latitude: latitude, longitude: longitude)

      @excluded = create(:firm_with_no_business_split, other_percent: 100)

      create(:adviser, firm: @excluded, latitude: latitude, longitude: longitude)
    end
  end

  def and_i_select_phone_or_online_advice
    # This is here to help make the feature steps read easier, but also
    # serves as a place-holder for when the search form markup becomes
    # one form and requires the advice method to be selected.
  end

  def and_i_select_the_phone_and_or_online_advice_types
    landing_page.remote.by_phone.set true
    landing_page.remote.online.set true
  end

  def and_i_indicate_that_i_need_help_with_my_pension_pot
    landing_page.remote.pension_pot.set true
  end

  def and_i_see_the_default_option_is_i_dont_know_or_wish_to_say
    expect(landing_page.remote.pension_pot_size.value).to eql(SearchForm::ANY_SIZE_VALUE)
  end

  def and_i_select_a_pot_size_band_from_the_available_options
    landing_page.remote.pension_pot_size.select @small_pot_size_firm.investment_sizes.sample.name
  end

  def and_i_indicate_that_i_dont_know_the_size_of_my_pension_pot
    landing_page.remote.pension_pot_size.select I18n.t('search_filter.pension_pot.any_size_option')
  end

  def and_i_indicate_that_i_would_like_to_transfer_my_pension
    landing_page.remote.pension_pot_transfer.set true
  end

  def when_i_submit_the_face_to_face_advice_search
    landing_page.remote.search.click
  end

  def when_i_submit_the_phone_or_online_advice_search
    landing_page.remote.search.click
  end

  def then_i_am_shown_firms_that_can_advise_on_pension_pots
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 3)
    expect(results_page.firm_names).to include(
      @small_pot_size_firm.registered_name,
      @medium_pot_size_firm.registered_name,
      @pension_transfer_firm.registered_name
    )
  end

  def then_i_am_shown_firms_that_can_advise_on_my_pension_pot_size
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 2)
    expect(results_page.firm_names).to include(@small_pot_size_firm.registered_name)
  end

  def then_i_am_shown_firms_that_can_assist_with_pension_transfers
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 1)
    expect(results_page.firm_names).to include(@pension_transfer_firm.registered_name)
  end
end
