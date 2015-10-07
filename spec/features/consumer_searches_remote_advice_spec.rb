RSpec.feature 'Consumer searches for phone or online advice',
              vcr: vcr_options_for_feature(:consumer_searches_remote_advice) do
  let(:landing_page) { LandingPage.new }
  let(:remote_results_page) { RemoteResultsPage.new }

  let!(:in_person_advice_methods) { create_list(:in_person_advice_method, 3) }

  let!(:phone_advice)  { create(:other_advice_method, name: 'Telephone', order: 1) }
  let!(:online_advice) { create(:other_advice_method, name: 'Online', order: 2) }

  scenario 'Selecting online and telephone advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_online_and_telephone_advice
      then_i_am_shown_firms_that_provide_advice_online_and_by_telephone
      and_they_are_ordered_alphabetically
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

  def given_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def and_they_are_ordered_alphabetically
    names = remote_results_page.firm_names

    expect(remote_results_page.firm_names).to eql(names.sort)
  end

  def when_i_submit_a_search_selecting_online_and_telephone_advice
    landing_page.search_filter.phone_or_online.set true
    landing_page.search_filter.search.click
  end

  def then_i_am_shown_firms_that_provide_advice_online_and_by_telephone
    expect(remote_results_page).to have_firms(count: 3)

    expect(remote_results_page.firm_names).not_to include(
      @only_in_person.registered_name,
      @in_person_and_also_remote.registered_name
    )
  end
end
