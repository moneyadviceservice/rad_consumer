RSpec.feature 'Firm profile page from an "in-person" search',
              vcr: vcr_options_for_feature(:firm_profile_for_in_person_search) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:profile_page) { ProfilePage.new }

  scenario 'viewing office information for an "in-person" search' do
    with_elastic_search! do
      given_firm_with_multiple_offices_has_been_indexed
      and_i_perform_an_in_person_search
      when_i_view_the_firm_profile
      and_i_select_the_offices_tab
      then_i_should_see_a_number_of_offices_listed
      and_they_should_be_ordered_by_closest_to_search_postcode
      and_the_email_address_for_the_nearest_office_is_prominent
    end
  end

  scenario 'viewing office information for an "phone or online" search' do
    with_elastic_search! do
      given_firm_with_multiple_offices_has_been_indexed
      and_i_perform_a_phone_or_online_search
      when_i_view_the_firm_profile
      then_the_email_address_for_the_main_office_is_prominent
    end
  end

  def given_firm_with_multiple_offices_has_been_indexed
    with_fresh_index! do
      @firm = create(:firm)
      create(:adviser, firm: @firm, postcode: 'RG2 8EE', latitude: 51.428473, longitude: -0.943616, travel_distance: 100)
      @firm.main_office.update_attributes!(email_address: 'main.office@example.com', address_line_one: '120 Holborn', address_line_two: 'London', address_town: 'London', address_county: nil, address_postcode: 'EC1N 2TD', latitude: 51.518148, longitude: -0.108013)
      create(:office, firm: @firm, email_address: 'local.1@example.com', address_line_one: 'Phoenix House', address_line_two: '18 King William St', address_town: 'London', address_county: nil, address_postcode: 'EC4N 7BP', latitude: 51.511224, longitude: -0.087422)
      create(:office, firm: @firm, email_address: 'local.2@example.com', address_line_one: '12 Leather Ln', address_line_two: 'London', address_town: 'London', address_county: nil, address_postcode: 'EC1N 7SS', latitude: 51.519144, longitude: -0.108927)

      @remote_firm = create(:firm, :with_remote_advice)
      @remote_firm.main_office.update_attributes!(email_address: 'remote@example.com')
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

  def and_i_select_the_offices_tab
    profile_page.office_tab.click
  end

  def then_i_should_see_a_number_of_offices_listed
    expect(profile_page.offices.length).to eq(3)
  end

  def and_they_should_be_ordered_by_closest_to_search_postcode
    expect(profile_page.offices.first.postcode.text).to eq('EC1N 7SS')
    expect(profile_page.offices.last.postcode.text).to eq('EC4N 7BP')
  end

  def and_the_email_address_for_the_nearest_office_is_prominent
    expect(profile_page.email[:href]).to eq('mailto:local.2@example.com')
  end

  def then_the_email_address_for_the_main_office_is_prominent
    expect(profile_page.email[:href]).to eq('mailto:remote@example.com')
  end
end
