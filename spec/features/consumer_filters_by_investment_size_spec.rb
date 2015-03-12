RSpec.feature 'Consumer filters by pension pot size' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let(:latitude) { rand(51.428473..55.856191) }
  let(:longitude) { rand(-4.247082..-0.943616) }

  scenario 'Consumer selects the pension pot size filter' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_with_advisers_were_previously_indexed
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_see_the_default_option_is_i_dont_know_or_wish_to_say
      and_i_select_an_applicable_pot_size_band_from_the_available_options
      when_i_submit_a_valid_postcode_search_with_the_selected_pot_size_band
      then_i_am_shown_firms_that_can_advise_on_my_chosen_investment_pot_size
    end
  end

  scenario 'Consumer I don\'t know / Don\'t wish to say' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_with_advisers_were_previously_indexed
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_see_the_default_option_is_i_dont_know_or_wish_to_say
      and_i_indicate_that_i_dont_know_the_size_of_my_pension_pot
      when_i_submit_a_valid_postcode_search_with_the_selected_pot_size_band
      then_i_am_shown_firms_that_can_advise_on_pension_pots
    end
  end

  scenario 'Consumer selects the pension transfer option' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_with_advisers_were_previously_indexed
      and_i_indicate_that_i_need_help_with_my_pension_pot
      and_i_see_the_default_option_is_i_dont_know_or_wish_to_say
      and_i_indicate_that_i_dont_know_the_size_of_my_pension_pot
      and_i_indicate_that_i_would_like_transfer_my_pension
      when_i_submit_a_valid_postcode_search_with_the_selected_pot_size_band
      then_i_am_shown_firms_that_can_assist_with_pension_transfers
    end
  end

  def given_i_am_on_the_rad_landing_page
    @investment_sizes = create_list(:investment_size, 5)
    landing_page.load
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @small_pot_size_firm = create(:firm_with_no_business_split, other_percent: 100, investment_sizes: @investment_sizes.values_at(0, 1))
      create_list(:adviser, 1, firm: @small_pot_size_firm, latitude: latitude, longitude: longitude)

      @pot_transfers_firm = create(:firm_with_no_business_split, pension_transfer_percent: 100, investment_sizes: @investment_sizes.values_at(4))
      create_list(:adviser, 2, firm: @pot_transfers_firm, latitude: latitude, longitude: longitude)

      @large_pot_size_firm = create(:firm_with_no_business_split, other_percent: 100, investment_sizes: @investment_sizes.values_at(2, 3))
      create_list(:adviser, 3, firm: @large_pot_size_firm, latitude: latitude, longitude: longitude)
    end
  end

  def and_i_indicate_that_i_need_help_with_my_pension_pot
    landing_page.in_person.pension_pot.set true
  end

  def and_i_see_the_default_option_is_i_dont_know_or_wish_to_say
    expect(landing_page.in_person.pension_pot_size.value).to eql(SearchFormFilters::ANY_SIZE_VALUE)
  end

  def and_i_select_an_applicable_pot_size_band_from_the_available_options
    landing_page.in_person.pension_pot_size.select @small_pot_size_firm.investment_sizes.sample.name
  end

  def and_i_indicate_that_i_dont_know_the_size_of_my_pension_pot
    landing_page.in_person.pension_pot_size.select I18n.t('search_filter.pension_pot.any_size_option')
  end

  def and_i_indicate_that_i_would_like_transfer_my_pension
    landing_page.in_person.pension_pot_transfer.set true
  end

  def when_i_submit_a_valid_postcode_search_with_the_selected_pot_size_band
    landing_page.in_person.tap do |section|
      section.postcode.set 'RG2 9FL'
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_can_advise_on_my_chosen_investment_pot_size
    expect(results_page).to be_displayed
    expect(results_page).to have_firms count: 1
    expect(results_page.firm_names).to include(@small_pot_size_firm.registered_name)
  end

  def then_i_am_shown_firms_that_can_advise_on_pension_pots
    expect(results_page).to be_displayed
    expect(results_page).to have_firms count: 3
    expect(results_page.firm_names).to include(
      @small_pot_size_firm.registered_name,
      @pot_transfers_firm.registered_name,
      @large_pot_size_firm.registered_name
    )
  end

  def then_i_am_shown_firms_that_can_assist_with_pension_transfers
    expect(results_page).to be_displayed
    expect(results_page).to have_firms count: 1
    expect(results_page.firm_names).to include(@pot_transfers_firm.registered_name)
  end
end
