RSpec.feature 'Consumer searches by postcode with types of advice filters' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:latitude) { rand(51.428473..55.856191) }
  let(:longitude) { rand(-4.247082..-0.943616) }

  scenario 'Types of advice search' do
    with_elastic_search! do
      given_that_i_am_on_the_rad_landing_page
      and_firms_that_provide_various_types_of_advice_were_previously_indexed
      when_i_submit_a_valid_postcode_search_with_selected_types_of_advice_filters
      then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    end
  end

  def given_that_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def and_firms_that_provide_various_types_of_advice_were_previously_indexed
    with_fresh_index! do
      @equity_and_wills_firm = create(:firm_with_no_business_split, equity_release_percent: 50, wills_and_probate_percent: 50)
      create_list(:adviser, 3, firm: @equity_and_wills_firm, latitude: latitude, longitude: longitude)

      @pension_and_other_firm = create(:firm_with_no_business_split, pension_transfer_percent: 50, other_percent: 50)
      create_list(:adviser, 3, firm: @pension_and_other_firm, latitude: latitude, longitude: longitude)
    end
  end

  def when_i_submit_a_valid_postcode_search_with_selected_types_of_advice_filters
    landing_page.in_person.tap do |section|
      section.postcode.set 'RG2 9FL'
      section.equity_release.set true
      section.wills_and_probate.set true
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    expect(results_page).to be_displayed
    expect(results_page).to have_firms count: 1
    expect(results_page.firms.first.name).to include(@equity_and_wills_firm.registered_name)
  end
end
