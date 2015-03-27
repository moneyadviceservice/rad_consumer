RSpec.feature 'Landing page, consumer requires general advice over the phone or online' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Using only the phone advice method' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_advice_method
      when_i_submit_the_phone_or_online_advice_search
      then_i_see_firms_that_provide_advice_over_the_phone
    end
  end

  scenario 'Using only the online advice method' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      and_i_select_the_online_advice_method
      when_i_submit_the_phone_or_online_advice_search
      then_i_see_firms_that_provide_advice_online
    end
  end

  scenario 'Using both the phone and online advice methods' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      and_i_select_both_the_phone_and_online_advice_methods
      when_i_submit_the_phone_or_online_advice_search
      then_i_see_firms_that_provide_advice_over_the_phone_or_online
    end
  end

  scenario 'Using no advice method' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      when_i_submit_the_phone_or_online_advice_search
      then_i_see_an_error_message
    end
  end

  def given_firms_with_advisers_were_previously_indexed
    other_advice_methods = [
      create(:other_advice_method, name: 'Phone', order: 1),
      create(:other_advice_method, name: 'Online', order: 2)
    ]

    with_fresh_index! do
      @phone_firm = create(:firm, other_advice_methods: [other_advice_methods.first])
      create(:adviser, firm: @phone_firm)

      @online_firm = create(:firm, other_advice_methods: [other_advice_methods.second])
      create(:adviser, firm: @online_firm)

      @excluded = create(:firm, other_advice_methods: [])
      create(:adviser, firm: @excluded)
    end
  end

  def and_i_am_on_the_landing_page
    landing_page.load
  end

  def and_i_select_phone_or_online_advice
    # This is here to help make the feature steps read easier, but also
    # serves as a place-holder for when the search form markup becomes
    # one form and requires the advice method to be selected.
  end

  def and_i_select_the_phone_advice_method
    landing_page.remote.by_phone.set true
  end

  def and_i_select_the_online_advice_method
    landing_page.remote.online.set true
  end

  def and_i_select_both_the_phone_and_online_advice_methods
    landing_page.remote.by_phone.set true
    landing_page.remote.online.set true
  end

  def when_i_submit_the_phone_or_online_advice_search
    landing_page.remote.search.click
  end

  def then_i_see_firms_that_provide_advice_over_the_phone
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 1)
    expect(results_page.firm_names).to include(@phone_firm.registered_name)
  end

  def then_i_see_firms_that_provide_advice_online
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 1)
    expect(results_page.firm_names).to include(@online_firm.registered_name)
  end

  def then_i_see_firms_that_provide_advice_over_the_phone_or_online
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 2)
    expect(results_page.firm_names).to include(
      @phone_firm.registered_name,
      @online_firm.registered_name
    )
  end

  def then_i_see_an_error_message
    expect(landing_page).to be_displayed
    expect(landing_page).to have_errors
  end
end
