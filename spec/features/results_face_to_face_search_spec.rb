RSpec.feature 'Results page, consumer requires help with their pension in person',
              vcr: vcr_options_for_feature(:results_face_to_face_search) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:phone_advice)  { create(:other_advice_method, name: 'Phone', order: 1) }
  let(:online_advice)  { create(:other_advice_method, name: 'Online', order: 2) }

  scenario 'Using only a valid postcode' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_a_valid_postcode 'RG2 9FL'
      when_i_submit_the_search
      then_i_see_firms_that_cover_my_postcode
    end
  end

  scenario 'Using an invalid postcode' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_an_invalid_postcode
      when_i_submit_the_search
      then_i_see_an_error_message_for_the_postcode_field
      and_i_see_a_message_in_place_of_the_results
    end
  end

  scenario 'Using a postcode that cannot be geocoded' do
    given_reference_data_has_been_populated

    with_elastic_search! do
      with_fresh_index!
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_a_postcode_that_cannot_be_geocoded
      when_i_submit_the_search
      then_i_see_an_error_message_for_the_postcode_field
      and_i_see_a_message_in_place_of_the_results
    end
  end

  def given_reference_data_has_been_populated
    phone_advice && online_advice
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @reading = create(:adviser, postcode: 'RG2 8EE', latitude: 51.428473, longitude: -0.943616, travel_distance: 100)
      @leicester = create(:adviser, postcode: 'LE1 6SL', latitude: 52.633013, longitude: -1.131257, travel_distance: 650)
      @glasgow = create(:adviser, postcode: 'G1 5QT', latitude: 55.856191, longitude: -4.247082, travel_distance: 10)

      @missing = create(:firm, in_person_advice_methods: [], other_advice_methods: [phone_advice]) do |firm|
        create(:adviser, firm: firm, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def and_i_enter_an_invalid_postcode
    results_page.search_form.postcode.set 'B4D'
  end

  def and_i_enter_a_postcode_that_cannot_be_geocoded
    results_page.search_form.postcode.set 'ZZ1 1ZZ'
  end

  def then_i_see_firms_that_cover_my_postcode
    expect(results_page).to be_displayed
    expect(results_page.firms).to be_present
  end

  def then_i_see_an_error_message_for_the_postcode_field
    expect(results_page).to have_errors
  end

  def and_i_see_a_message_in_place_of_the_results
    expect(results_page.incorrect_criteria_message).to be_present
  end
end
