RSpec.feature 'Results page, consumer requires help with their pension over the phone or online' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let(:latitude) { rand(51.428473..55.856191) }
  let(:longitude) { rand(-4.247082..-0.943616) }

  scenario 'Filter for general pension pot advice' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_methods
      and_i_indicate_that_i_need_help_with_my_pension_pot
      when_i_submit_the_search
      then_i_am_shown_firms_that_can_advise_on_pension_pots
    end
  end

  scenario 'Filter for advice on a pension pot size' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_methods
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_select_a_pot_size_band_from_the_available_options
      when_i_submit_the_search
      then_i_am_shown_firms_that_can_advise_on_my_pension_pot_size
    end
  end

  scenario 'Filter for advice on pension pot transfers' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_methods
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_select_a_pot_size_band_from_the_available_options
      and_i_indicate_that_i_would_like_to_transfer_my_pension
      when_i_submit_the_search
      then_i_am_shown_firms_that_can_assist_with_pension_transfers
    end
  end

  def given_reference_data_has_been_populated
    @investment_sizes = create_list(:investment_size, 5)

    @other_advice_methods = [
      create(:other_advice_method, name: 'Phone', order: 1),
      create(:other_advice_method, name: 'Online', order: 2)
    ]
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @small_pot_size_firm = create(:firm_with_no_business_split, retirement_income_products_percent: 90, other_percent: 10, investment_sizes: @investment_sizes.values_at(0, 1), other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @small_pot_size_firm, latitude: latitude, longitude: longitude)

      @medium_pot_size_firm = create(:firm_with_no_business_split, retirement_income_products_percent: 10, other_percent: 90, investment_sizes: @investment_sizes.values_at(2, 3), other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @medium_pot_size_firm, latitude: latitude, longitude: longitude)

      @pension_transfer_firm = create(:firm_with_no_business_split, retirement_income_products_percent: 50, pension_transfer_percent: 50, investment_sizes: @investment_sizes, other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @pension_transfer_firm, latitude: latitude, longitude: longitude)

      @excluded = create(:firm_with_no_business_split, other_percent: 100, other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @excluded, latitude: latitude, longitude: longitude)
    end
  end

  def and_i_am_on_the_results_page_after_a_previous_search
    landing_page.load
    landing_page.in_person.tap do |f|
      f.postcode.set 'RG2 9FL'
      f.search.click
    end

    expect(results_page).to be_displayed
  end

  def and_i_clear_any_filters_from_the_previous_search
    results_page.search_form.tap do |f|
      f.face_to_face.set false
      f.phone_or_online.set false

      f.postcode.set nil
      f.phone.set false
      f.online.set false

      f.retirement_income_products.set false
      f.pension_pot_size.set SearchForm::ANY_SIZE_VALUE
      f.pension_transfer.set false
      f.options_when_paying_for_care.set false
      f.equity_release.set false
      f.inheritance_tax_planning.set false
      f.wills_and_probate.set false
    end
  end

  def and_i_select_phone_or_online_advice
    results_page.search_form.phone_or_online.set true
  end

  def and_i_select_the_phone_and_or_online_advice_methods
    results_page.search_form.phone.set true
    results_page.search_form.online.set true
  end

  def and_i_indicate_that_i_need_help_with_my_pension_pot
    results_page.search_form.retirement_income_products.set true
  end

  def and_i_select_a_pot_size_band_from_the_available_options
    results_page.search_form.pension_pot_size.select @small_pot_size_firm.investment_sizes.sample.name
  end

  def and_i_indicate_that_i_dont_know_the_size_of_my_pension_pot
    results_page.search_form.pension_pot_size.select I18n.t('search_filter.pension_pot.any_size_option')
  end

  def and_i_indicate_that_i_would_like_to_transfer_my_pension
    results_page.search_form.pension_transfer.set true
  end

  def when_i_submit_the_search
    results_page.search_form.search.click
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