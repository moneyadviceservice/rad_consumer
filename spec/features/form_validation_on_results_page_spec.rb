RSpec.feature 'Consumer reads validation failures on the search results page' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let!(:phone_advice)  { create(:other_advice_method, name: 'Advice by telephone', order: 1) }
  let!(:online_advice) { create(:other_advice_method, name: 'Advice online (e.g. by video call / conference / email)', order: 2) }

  scenario 'Consumer provides no postcode' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_have_performed_a_remote_search_from_the_landing_page
      when_i_switch_to_remote_advice
      and_i_do_not_select_advice_type
      and_i_resubmit_the_form
      then_i_can_see_advice_method_validation_error
      and_previous_search_criteria_are_selected
      and_i_am_still_on_results_page
    end
  end

  scenario 'Consumer does not select remote advice method' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_have_performed_an_in_person_search_from_the_landing_page
      when_i_switch_to_in_person_advice
      and_i_do_not_enter_postcode
      and_i_resubmit_the_form
      then_i_can_see_postcode_validation_error
      and_previous_search_criteria_are_selected
      and_i_am_still_on_results_page
    end
  end


  def given_some_firms_were_indexed
    with_fresh_index! do
      @phone_firm = create(:firm, registered_name: 'The Willers Ltd', in_person_advice_methods: [], other_advice_methods: [ phone_advice ])
      create(:adviser, postcode: 'RG2 8EE', firm: @phone_firm,       latitude: 51.428473, longitude: -0.943616)

      @online_firm = create(:firm, registered_name: 'The Equiters Ltd', in_person_advice_methods: [], other_advice_methods: [ online_advice ])
      create(:adviser, postcode: 'LE1 6SL', firm: @online_firm, latitude: 52.633013, longitude: -1.131257)

      @in_person_firm = create(:firm, registered_name: 'Estate Traders Ltd', other_advice_methods: [])
      create(:adviser, postcode: 'G1 5QT', firm: @in_person_firm, latitude: 55.856191, longitude: -4.247082)
    end
  end

  def and_i_have_performed_an_in_person_search_from_the_landing_page
    landing_page.load
    landing_page.in_person.tap do |section|
      section.postcode.set 'G1 5QT'
      section.equity_release.set(true)
      section.search.click
    end
  end

  def and_i_have_performed_a_remote_search_from_the_landing_page
    landing_page.load
    landing_page.remote.tap do |section|
      section.online.set(true)
      section.search.click
    end
  end

  def when_i_switch_to_in_person_advice
    results_page.criteria.in_person_advice.set(true)
  end

  def when_i_switch_to_remote_advice
    results_page.criteria.remote_advice.set(true)
  end

  def and_i_do_not_select_advice_type
    # placeholder to provide better reading for the scenario
  end

  def and_i_do_not_enter_postcode
    # placeholder to provide better reading for the scenario
  end

  def then_i_can_see_postcode_validation_error
    pending
    expect(results_page.criteria).to be_postcode_validation_error
  end

  def then_i_can_see_advice_method_validation_error
    pending
    expect(results_page.criteria).to be_advice_method_validation_error
  end

  def and_i_am_still_on_results_page
    expect(results_page).to be_displayed
  end

  def and_i_resubmit_the_form
    results_page.criteria.search.click
  end

  def and_previous_face_to_face_criteria_are_selected
    expect(results_page.criteria.postcode).to eq 'G1 5QT'
    expect(results_page.advice_method).to eq 'face_to_face'
  end

  def and_previous_remote_criteria_are_selected
    expect(results_page.criteria.online).to eq true
    expect(results_page.advice_method).to eq 'phone_or_online'
  end
end
