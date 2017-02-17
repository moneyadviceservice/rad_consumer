RSpec.feature 'Search for firm',
              vcr: vcr_options_for_feature(:search_by_firm_name) do
  let!(:phone_advice)  { create(:other_advice_method, name: 'Advice by telephone', order: 1) }
  let!(:online_advice) { create(:other_advice_method, name: 'Advice online (e.g. by video call / conference / email)', order: 2) }
  let(:landing_page) { LandingPage.new }
  let(:profile_page) { ProfilePage.new }

  scenario 'search for firm by name' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_am_on_the_rad_landing_page
      when_i_search_for_an_existing_firm
      then_i_should_see_the_firm_in_search_results
      and_i_should_not_see_other_firms_with_dissimilar_name
    end
  end

  scenario 'search for similar firms' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_am_on_the_rad_landing_page
      when_i_do_a_full_name_search_for_an_existing_firm
      then_i_should_see_similar_firms_in_the_search_results
    end
  end

  scenario 'viewing firms from the search results page' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_am_on_the_rad_landing_page
      when_i_do_a_full_name_search_for_an_existing_firm
      when_i_view_the_second_firm_profile
      then_i_should_see_the_second_firm_profile
    end
  end

  def given_some_firms_were_indexed
    with_fresh_index! do
      @phone_firm = create(:firm, registered_name: 'The Willers Ltd', in_person_advice_methods: [], other_advice_methods: [phone_advice])
      create(:adviser, postcode: 'RG2 8EE', firm: @phone_firm, latitude: 51.428473, longitude: -0.943616)

      @online_firm = create(:firm, registered_name: 'The Equiters Ltd', in_person_advice_methods: [], other_advice_methods: [online_advice])
      create(:adviser, postcode: 'LE1 6SL', firm: @online_firm, latitude: 52.633013, longitude: -1.131257)

      @in_person_firm = create(:firm, registered_name: 'Pall Mall Financial Services Ltd', other_advice_methods: [])
      create(:adviser, postcode: 'G1 5QT', firm: @in_person_firm, latitude: 55.856191, longitude: -4.247082)
    end
  end

  def and_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def when_i_search_for_an_existing_firm
    landing_page.load
    landing_page.search_filter.firm_name_option.set true
    landing_page.firm_search.firm_name.set 'Pall Mall'

    landing_page.search.click
  end

  def when_i_view_the_second_firm_profile
    landing_page.firms.sort[1].view_profile.click
    expect(profile_page).to be_displayed
  end

  def then_i_should_see_the_firm_in_search_results
    expect(landing_page).to have_content('Pall Mall Financial Services Ltd')
  end

  def when_i_do_a_full_name_search_for_an_existing_firm
    landing_page.load
    landing_page.search_filter.firm_name_option.set true
    landing_page.firm_search.firm_name.set 'Pall Mall Financial Services Ltd'

    landing_page.search.click
  end

  def and_i_should_not_see_other_firms_with_dissimilar_name
    expect(landing_page).not_to have_content('The Equiters Ltd')
    expect(landing_page).not_to have_content('The Willers Ltd')
  end

  def then_i_should_see_similar_firms_in_the_search_results
    expect(landing_page).to have_content('The Equiters Ltd')
    expect(landing_page).to have_content('The Willers Ltd')
  end

  def then_i_should_see_the_second_firm_profile
    expect(profile_page).to have_content('The Equiters Ltd')
    expect(profile_page.telephone.text).to eq('07111 333 222')
  end
end
