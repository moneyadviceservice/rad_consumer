RSpec.feature 'Consumer views channel filters on search results page' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let!(:phone_advice)  { create(:other_advice_method, name: 'Advice by telephone', order: 1) }
  let!(:online_advice) { create(:other_advice_method, name: 'Advice online (e.g. by video call / conference / email)', order: 2) }

  scenario 'Consumer views current filters applied to their search' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_am_on_the_rad_landing_page
      when_i_select_a_remote_advice_method
      and_i_submit_the_remote_search_form
      then_i_am_on_results_page
      and_i_see_remote_advice_method_selected
      and_only_remote_firms_are_displayed
    end
  end

  scenario 'Consumer changes advice method from in person to remote' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_have_performed_an_in_person_search_from_the_landing_page
      when_i_select_remote_advice
      and_i_submit_the_sidebar_search_form
      then_i_am_on_results_page
      and_i_see_remote_advice_method_selected
      and_only_remote_firms_are_displayed
      and_i_see_a_notice_that_the_order_is_alphabetical
    end
  end

  scenario 'Consumer changes advice method from remote to in person' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_have_performed_a_remote_search_from_the_landing_page
      when_i_select_face_to_face_advice
      and_i_submit_the_sidebar_search_form
      then_i_am_on_results_page
      and_i_see_face_to_face_advice_method_selected
      and_only_in_person_firms_are_displayed
      and_i_see_a_notice_that_the_order_is_distance_based
    end
  end

  scenario 'Consumer changes advice method to in person without providing postcode' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_have_performed_a_remote_search_from_the_landing_page
      when_i_select_face_to_face_advice_without_providing_postcode
      and_i_submit_the_sidebar_search_form
      then_i_am_on_the_landing_page
      and_a_validation_error_message_is_displayed
    end
  end

  scenario 'Consumer changes advice method to remote without selecting remote advice type' do
    with_elastic_search! do
      given_some_firms_were_indexed
      and_i_have_performed_an_in_person_search_from_the_landing_page
      when_i_select_remote_advice_without_providing_type
      and_i_submit_the_sidebar_search_form
      then_i_am_on_the_landing_page
      and_a_validation_error_message_is_displayed
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

  def and_i_am_on_the_rad_landing_page
    landing_page.load
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

  def when_i_select_a_remote_advice_method
    landing_page.load
    landing_page.in_person.tap do |section|
      section.online.set(true)
      section.search.click
    end
  end

  def when_i_select_remote_advice
    results_page.criteria.remote_advice.set(true)
    results_page.criteria.online.set(true)
  end

  def when_i_select_face_to_face_advice_without_providing_postcode
    results_page.criteria.in_person_advice.set(true)
  end

  def when_i_select_remote_advice_without_providing_type
    results_page.criteria.remote_advice.set(true)
  end

  def and_i_submit_the_sidebar_search_form
    results_page.criteria.search.click
  end

  def and_i_submit_the_remote_search_form
    landing_page.remote.search.click
  end

  def when_i_select_a_remote_advice_method
    landing_page.remote.online.set(true)
  end

  def when_i_select_face_to_face_advice
    results_page.criteria.in_person_advice.set(true)
    results_page.criteria.postcode.set 'G1 5QT'
  end

  def and_i_submit_the_face_to_face_search_form
    landing_page.remote.search.click
  end

  def and_i_submit_the_remote_search_form
    landing_page.remote.search.click
  end

  def then_i_am_on_results_page
    expect(results_page).to be_displayed
  end

  def and_i_see_remote_advice_method_selected
    expect(results_page.criteria.remote_advice).to be_checked
    expect(results_page.criteria.online).to be_checked
  end

  def and_i_see_face_to_face_advice_method_selected
    expect(results_page.criteria.in_person_advice).to be_checked
  end

  def then_i_am_on_the_landing_page
    expect(landing_page).to be_displayed
  end

  def and_a_validation_error_message_is_displayed
    expect(landing_page).to be_invalid_parameters
  end

  def and_only_remote_firms_are_displayed
    expect(results_page.firm_names).to contain_exactly(@online_firm.registered_name)
  end

  def and_only_in_person_firms_are_displayed
    expect(results_page.firm_names).to contain_exactly(@in_person_firm.registered_name)
  end

  def and_i_see_a_notice_that_the_order_is_alphabetical
    expect(results_page.order_notice).to have_text I18n.t('search.alphabetical_order_notice')
  end

  def and_i_see_a_notice_that_the_order_is_distance_based
    expect(results_page.order_notice).to have_text I18n.t('search.distance_order_notice')
  end
end
