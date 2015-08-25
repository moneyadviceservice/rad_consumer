RSpec.feature 'Consumer searches for phone or online advice',
              vcr: vcr_options_for_feature(:consumer_searches_remote_advice) do
  let(:landing_page) { LandingPage.new }
  let(:remote_results_page) { RemoteResultsPage.new }

  let!(:in_person_advice_methods) { create_list(:in_person_advice_method, 3) }

  let!(:phone_advice)  { create(:other_advice_method, name: 'Telephone', order: 1) }
  let!(:online_advice) { create(:other_advice_method, name: 'Online', order: 2) }

  scenario 'Selecting telephone advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_telephone_advice
      then_i_am_shown_firms_that_provide_advice_by_telephone
      and_they_are_ordered_alphabetically
      and_i_am_not_shown_the_advisers_distance
    end
  end

  scenario 'Selecting online advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_online_advice
      then_i_am_shown_firms_that_provide_advice_online
      and_they_are_ordered_alphabetically
    end
  end

  scenario 'Selecting online and telephone advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_online_and_telephone_advice
      then_i_am_shown_firms_that_provide_advice_online_and_by_telephone
      and_they_are_ordered_alphabetically
    end
  end

  scenario 'Selecting phone and/or online advice with advice filters' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_various_types_of_remote_services_were_indexed
      when_i_submit_a_search_selecting_remote_advice_and_types_of_advice
      then_i_am_shown_filtered_firms_list
      and_the_list_does_not_include_offline_only_advisories
      and_they_are_ordered_alphabetically
    end
  end

  scenario 'Consumer runs a remote advice search without selecting phone or online' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_without_selecting_advice_methods
      then_i_am_shown_an_error_message
      and_i_am_still_on_landing_page
    end
  end

  def and_firms_providing_remote_services_were_previously_indexed
    with_fresh_index! do
      # Remote options only
      @online_only = create(:firm, registered_name: 'The End Advisory', in_person_advice_methods: [], other_advice_methods: [online_advice])
      @online_and_phone = create(:firm, registered_name: 'Remoteley Advisory', in_person_advice_methods: [], other_advice_methods: [online_advice, phone_advice])
      @phone_only = create(:firm, registered_name: 'Cold Callers Limited', in_person_advice_methods: [], other_advice_methods: [phone_advice])

      # Face to face options only
      @only_in_person = create(:firm, registered_name: 'ACME Retirement Advice', in_person_advice_methods: in_person_advice_methods, other_advice_methods: [])

      # Face to face but some of the optional remote options checked too
      @in_person_and_also_remote = create(:firm, registered_name: 'ACME Retirement Advice', in_person_advice_methods: in_person_advice_methods, other_advice_methods: [online_advice, phone_advice])
    end
  end

  def and_firms_providing_various_types_of_remote_services_were_indexed
    with_fresh_index! do
      # Remote options only
      @equity = create(:firm_with_no_business_split, registered_name: 'Equity release advisory', pension_transfer_flag: true, in_person_advice_methods: [], other_advice_methods: [online_advice, phone_advice])
      @wills = create(:firm_with_no_business_split, registered_name: 'Wills advisory', equity_release_flag: true, in_person_advice_methods: [], other_advice_methods: [online_advice, phone_advice])
      @probate = create(:firm_with_no_business_split, registered_name: 'Probate advisory', equity_release_flag: true, wills_and_probate_flag: true, in_person_advice_methods: [], other_advice_methods: [online_advice, phone_advice])
      @wills_and_equity = create(:firm_with_no_business_split, registered_name: 'Paying for care and equity advisory', equity_release_flag: true, wills_and_probate_flag: true, in_person_advice_methods: [], other_advice_methods: [online_advice, phone_advice])

      # Face to face options only
      @in_person_and_wills = create(:firm_with_no_business_split, registered_name: 'Wills Face to Face Advice Ltd', equity_release_flag: true, wills_and_probate_flag: true, in_person_advice_methods: in_person_advice_methods, other_advice_methods: [])

      # Face to face but some of the optional remote options checked too
      @in_person_and_also_remote = create(:firm_with_no_business_split, registered_name: 'Wills Face to Face or Phone Advice Ltd', equity_release_flag: true, wills_and_probate_flag: true, in_person_advice_methods: in_person_advice_methods, other_advice_methods: [online_advice, phone_advice])
    end
  end

  def given_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def when_i_submit_a_search_selecting_online_advice
    landing_page.remote.tap do |section|
      section.online.set true
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_advice_online
    expect(remote_results_page.firm_names).to include(
      @online_only.registered_name,
      @online_and_phone.registered_name
    )

    expect(remote_results_page.firm_names).not_to include(
      @in_person_and_also_remote.registered_name
    )
  end

  def and_they_are_ordered_alphabetically
    names = remote_results_page.firm_names

    expect(remote_results_page.firm_names).to eql(names.sort)
  end

  def when_i_submit_a_search_selecting_telephone_advice
    landing_page.remote.tap do |section|
      section.by_phone.set true
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_advice_by_telephone
    names = remote_results_page.firm_names

    expect(names).to include(
      @phone_only.registered_name,
      @online_and_phone.registered_name
    )

    expect(names).not_to include(
      @only_in_person.registered_name,
      @online_only.registered_name,
      @in_person_and_also_remote.registered_name
    )
  end

  def when_i_submit_a_search_selecting_online_and_telephone_advice
    landing_page.remote.tap do |section|
      section.online.set true
      section.by_phone.set true
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_advice_online_and_by_telephone
    expect(remote_results_page).to have_firms(count: 3)

    expect(remote_results_page.firm_names).not_to include(
      @only_in_person.registered_name,
      @in_person_and_also_remote.registered_name
    )
  end

  def when_i_submit_a_search_without_selecting_advice_methods
    landing_page.remote.search.click
  end

  def then_i_am_shown_an_error_message
    expect(landing_page.remote).to be_invalid_advice_methods
  end

  def and_i_am_still_on_landing_page
    expect(landing_page).to be_displayed
  end

  def when_i_submit_a_search_selecting_remote_advice_and_types_of_advice
    landing_page.remote.tap do |section|
      section.equity_release.set true
      section.wills_and_probate.set true
      section.online.set true
      section.by_phone.set true
      section.search.click
    end
  end

  def then_i_am_shown_filtered_firms_list
    expect(remote_results_page).to have_firms(count: 2)

    expect(remote_results_page.firm_names).to include(
      @probate.registered_name,
      @wills_and_equity.registered_name
    )
  end

  def and_the_list_does_not_include_offline_only_advisories
    expect(remote_results_page.firm_names).not_to include(@in_person_and_wills.registered_name)
  end

  def and_i_am_not_shown_the_advisers_distance
    expect(remote_results_page.firms.first).not_to have_adviser_distance
  end
end
