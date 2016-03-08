RSpec.feature 'Results page, consumer requires help with their pension in person',
              vcr: vcr_options_for_feature(:results_face_to_face_filter_for_pension_advice) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let(:latitude) { rand(51.428473..55.856191) }
  let(:longitude) { rand(-4.247082..-0.943616) }

  scenario 'Filter for advice on a pension pot size' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_a_valid_postcode 'RG2 9FL'
      and_i_need_to_speak_to_an_adviser_in_bulgarian
      when_i_submit_the_search
      then_i_am_shown_firms_that_can_advise_in_bulgarian
    end
  end

  def given_reference_data_has_been_populated
    create(:other_advice_method, name: 'Phone', order: 1)
    create(:other_advice_method, name: 'Online', order: 2)
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @bulgarian_speaking_firm = create(:firm, languages: ['bul'])
      create(:adviser, firm: @bulgarian_speaking_firm, latitude: latitude, longitude: longitude)

      @excluded = create(:firm, languages: ['afr'])
      create(:adviser, firm: @excluded, latitude: latitude, longitude: longitude)
    end
  end

  def and_i_need_to_speak_to_an_adviser_in_bulgarian
    results_page.search_form.languages.select 'Bulgarian'
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

  def then_i_am_shown_firms_that_can_advise_in_bulgarian
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 1)
    expect(results_page.firm_names).to include(@bulgarian_speaking_firm.registered_name)
  end
end
