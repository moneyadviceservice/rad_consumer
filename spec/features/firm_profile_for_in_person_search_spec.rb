RSpec.feature 'Firm profile page from an "in-person" search',
              vcr: vcr_options_for_feature(:firm_profile_for_in_person_search) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:profile_page) { ProfilePage.new }

  scenario 'viewing office information' do
    with_elastic_search! do
      given_firm_with_two_offices_has_been_indexed
      and_i_perform_an_in_person_search
      when_i_view_the_firm_profile
      and_i_select_the_offices_tab
      then_i_should_see_both_offices_listed
    end
  end

  def given_firm_with_two_offices_has_been_indexed
    with_fresh_index! do
      @firm = create(:firm)
      create(:adviser, firm: @firm, postcode: 'RG2 8EE', latitude: 51.428473, longitude: -0.943616, travel_distance: 100)
      create(:office, firm: @firm)
    end
  end

  def and_i_perform_an_in_person_search
    landing_page.load
    landing_page.in_person.tap do |f|
      f.postcode.set 'RG2 9FL'
      f.search.click
    end

    expect(results_page).to be_displayed
  end

  def when_i_view_the_firm_profile
    results_page.firms.first.view_profile.click
    expect(profile_page).to be_displayed
  end

  def and_i_select_the_offices_tab
    profile_page.office_tab.click
  end

  def then_i_should_see_both_offices_listed
    expect(profile_page.offices.length).to eq(2)
  end
end
