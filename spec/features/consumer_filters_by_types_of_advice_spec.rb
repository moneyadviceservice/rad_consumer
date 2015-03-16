RSpec.feature 'Consumer searches by postcode with types of advice filters' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Types of advice search' do
    pending 'WIP'

    with_elastic_search! do
      given_that_i_am_on_the_rad_landing_page
      and_firms_that_provide_various_types_of_advice_were_previously_indexed
      when_i_submit_a_valid_postcode_search_with_selected_types_of_advice_filters
      then_i_am_shown_firms_that_provide_the_selected_types_of_advice
      and_they_are_ordered_by_business_split_and_location
    end
  end

  def given_that_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def and_firms_that_provide_various_types_of_advice_were_previously_indexed
    with_fresh_index! do
      @first = create(:firm_with_no_business_split, pension_transfer_percent: 30, wills_and_probate_percent: 20, other_percent: 50) do |f|
        @glasgow = create(:adviser, firm: f, latitude: 55.856191, longitude: -4.247082)
      end

      @second = create(:firm_with_no_business_split, pension_transfer_percent: 29, wills_and_probate_percent: 20, other_percent: 51) do |f|
        @leicester = create(:adviser, firm: f, latitude: 52.633013, longitude: -1.131257)
      end

      create(:firm_with_no_business_split, pension_transfer_percent: 49, other_percent: 51) do |f|
        create(:adviser, firm: f, latitude: 51.428473, longitude: -0.943616)
      end

      create(:firm_with_no_business_split, other_percent: 100) do |f|
        create(:adviser, firm: f, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def when_i_submit_a_valid_postcode_search_with_selected_types_of_advice_filters
    landing_page.in_person.tap do |section|
      section.postcode.set 'RG2 9FL'
      section.pension_pot.set true
      section.wills_and_probate.set true
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 2)
  end

  def and_they_are_ordered_by_business_split_and_location
    ordered_results = [@first, @second].map(&:registered_name)

    expect(results_page.firm_names).to eql(ordered_results)
  end
end
