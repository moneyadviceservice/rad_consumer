RSpec.feature 'Consumer views advice filters on search results page' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Consumer views current filters applied to their search' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_am_on_the_rad_landing_page
      when_i_search_with_a_reading_postcode
      then_i_am_on_search_results_page
      and_advice_filters_are_shown
      and_previously_selected_filters_are_selected_by_default
    end
  end

  scenario 'Consumer views updated search results' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_have_performed_a_search_from_the_landing_page
      when_i_amend_some_of_the_filters
      and_i_rerun_my_search
      then_i_am_on_search_results_page
      and_my_search_results_match_the_new_criteria
    end
  end


  def and_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def given_some_firms_were_indexed
    with_fresh_index! do
      @wills_firm       = create(:firm_with_no_business_split, registered_name: 'The Willers Ltd',    wills_and_probate_percent: 100)
      @equity_firm      = create(:firm_with_no_business_split, registered_name: 'The Equiters Ltd',   equity_release_percent: 100)
      @inheritance_firm = create(:firm_with_no_business_split, registered_name: 'Estate Traders Ltd', inheritance_tax_and_estate_planning_percent: 100)

      @reading   = create(:adviser, postcode: 'RG2 8EE', firm: @wills_firm,       latitude: 51.428473, longitude: -0.943616)
      @leicester = create(:adviser, postcode: 'LE1 6SL', firm: @equity_firm,      latitude: 52.633013, longitude: -1.131257)
      @glasgow   = create(:adviser, postcode: 'G1 5QT',  firm: @inheritance_firm, latitude: 55.856191, longitude: -4.247082)

      @missing = create(:firm, in_person_advice_methods: []) do |firm|
        create(:adviser, firm: firm, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def and_i_have_performed_a_search_from_the_landing_page
    landing_page.load
    landing_page.in_person.tap do |section|
      section.postcode.set('G1 5QT')
      section.equity_release.set(true)
      section.search.click
    end
  end

  def when_i_search_with_a_reading_postcode
    landing_page.in_person.tap do |section|
      section.postcode.set('G1 5QT')
      section.search.click
    end
  end

  def then_i_am_on_search_results_page
    expect(results_page).to be_displayed
  end

  def and_advice_filters_are_shown
    expect(results_page.criteria).to be
  end

  def and_previously_selected_filters_are_selected_by_default
    expect(results_page.criteria.postcode.value).to eql('G1 5QT')
  end

  def when_i_amend_some_of_the_filters
    results_page.criteria.wills_and_probate.set(true)
    results_page.criteria.equity_release.set(false)
  end

  def and_i_rerun_my_search
    results_page.criteria.search.click
  end

  def and_my_search_results_match_the_new_criteria
    expect(results_page.firm_names).to include(@wills_firm.registered_name)
    expect(results_page.firm_names).not_to include(@equity_firm.registered_name)
  end
end
