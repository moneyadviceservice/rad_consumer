RSpec.feature 'Firm profile advisers tab', vcr: vcr_options_for_feature(:firm_profile_advisers_tab) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:profile_page) { ProfilePage.new }

  scenario 'viewing advisers information for an "in-person" search' do
    with_elastic_search! do
      given_firm_with_multiple_advisers_has_been_indexed
      and_i_perform_an_in_person_search
      when_i_view_the_firm_profile
      and_i_select_the_advisers_tab
      then_i_should_see_a_number_of_advisers_listed
      and_they_should_be_ordered_by_closest_to_search_postcode
    end
  end

  scenario 'viewing advisers information for a "phone or online" search' do
    with_elastic_search! do
      given_firm_with_multiple_advisers_has_been_indexed
      and_i_perform_a_phone_or_online_search
      when_i_view_the_firm_profile
      then_i_should_see_a_number_of_remote_advisers_listed
      and_they_should_be_ordered_alphabetically
    end
  end

  def given_firm_with_multiple_advisers_has_been_indexed
    with_fresh_index! do
      @firm = create(:firm_without_advisers)
      create(:adviser, name: 'in the middle', firm: @firm, postcode: 'EC1N 2TD', latitude: 51.518148, longitude: -0.108013, travel_distance: 100)
      create(:adviser, name: 'furthest', firm: @firm, postcode: 'EC4N 7BP', latitude: 51.511224, longitude: -0.087422, travel_distance: 100)
      create(:adviser, name: 'nearest', firm: @firm, postcode: 'EC1N 7SS', latitude: 51.519144, longitude: -0.108927, travel_distance: 100)

      @remote_firm = create(:firm_without_advisers, :with_remote_advice)
      create(:adviser, name: 'C', firm: @remote_firm, postcode: 'EC1N 7SS', latitude: 51.519144, longitude: -0.108927, travel_distance: 100)
      create(:adviser, name: 'B', firm: @remote_firm, postcode: 'EC4N 7BP', latitude: 51.511224, longitude: -0.087422, travel_distance: 100)
      create(:adviser, name: 'A', firm: @remote_firm, postcode: 'EC1N 2TD', latitude: 51.518148, longitude: -0.108013, travel_distance: 100)
    end
  end

  def and_i_perform_an_in_person_search
    landing_page.load
    landing_page.in_person.tap do |f|
      f.postcode.set 'EC1N 7SS'
      f.search.click
    end

    expect(results_page).to be_displayed
  end

  def and_i_perform_a_phone_or_online_search
    landing_page.load
    landing_page.search_filter.phone_or_online.set true
    landing_page.search_filter.search.click

    expect(results_page).to be_displayed
  end

  def when_i_view_the_firm_profile
    results_page.firms.first.view_profile.click
    expect(profile_page).to be_displayed
  end

  def and_i_select_the_advisers_tab
    profile_page.adviser_tab.click
  end

  def then_i_should_not_see_the_advisers_tab
    expect(profile_page).to_not have_adviser_tab
  end

  def then_i_should_see_a_number_of_advisers_listed
    expect(profile_page.advisers.length).to eq(3)
  end

  def then_i_should_see_a_number_of_remote_advisers_listed
    expect(profile_page.advisers.length).to eq(3)
  end

  def and_they_should_be_ordered_by_closest_to_search_postcode
    expect(profile_page.advisers.map { |a| a.name.text }).to eq(['nearest', 'in the middle', 'furthest'])
  end

  def and_they_should_be_ordered_alphabetically
    expect(profile_page.advisers.map { |a| a.name.text }).to eq(%w(A B C))
  end
end
