RSpec.feature 'Landing page, consumer requires general advice over the phone or online',
              vcr: vcr_options_for_feature(:landing_phone_or_online_search) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Using both the phone and online advice methods' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      when_i_submit_the_phone_or_online_advice_search
      then_i_see_firms_that_provide_advice_over_the_phone_or_online
    end
  end

  def given_firms_with_advisers_were_previously_indexed
    other_advice_methods = [
      create(:other_advice_method, name: 'Phone', order: 1),
      create(:other_advice_method, name: 'Online', order: 2)
    ]

    in_person_advice_methods = create_list(:in_person_advice_method, 3)

    with_fresh_index! do
      @phone_firm = create(:firm, in_person_advice_methods: [], other_advice_methods: [other_advice_methods.first])
      create(:adviser, firm: @phone_firm)

      @online_firm = create(:firm, in_person_advice_methods: [], other_advice_methods: [other_advice_methods.second])
      create(:adviser, firm: @online_firm)

      @excluded = create(:firm, in_person_advice_methods: in_person_advice_methods, other_advice_methods: [])
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
    landing_page.search_filter.phone_or_online.set true
  end

  def when_i_submit_the_phone_or_online_advice_search
    landing_page.search_filter.search.click
  end

  def then_i_see_firms_that_provide_advice_over_the_phone_or_online
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 2)
    expect(results_page.firm_names).to include(
      @phone_firm.registered_name,
      @online_firm.registered_name
    )
  end
end
