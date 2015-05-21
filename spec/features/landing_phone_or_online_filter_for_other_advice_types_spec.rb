RSpec.feature 'Landing page, consumer requires various types of advice over the phone or online',
              vcr: vcr_options_for_feature(:landing_phone_or_online_filter_for_other_advice_types) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Filter for various types of advice' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_methods
      and_i_indicate_i_need_advice_on_various_topics
      when_i_submit_the_phone_or_online_advice_search
      then_i_am_shown_firms_that_provide_the_selected_types_of_advice
      and_they_are_ordered_by_name
    end
  end

  def given_firms_with_advisers_were_previously_indexed
    other_advice_methods = [
      create(:other_advice_method, name: 'Advice by telephone', order: 1),
      create(:other_advice_method, name: 'Advice online (e.g. by video call / conference / email)', order: 2)
    ]

    with_fresh_index! do
      @first = create(:firm_with_no_business_split, retirement_income_products_percent: 30, wills_and_probate_percent: 20, other_percent: 50, other_advice_methods: other_advice_methods)
      @glasgow = create(:adviser, firm: @first, latitude: 55.856191, longitude: -4.247082)

      @second = create(:firm_with_no_business_split, retirement_income_products_percent: 29, wills_and_probate_percent: 20, other_percent: 51, other_advice_methods: other_advice_methods)
      @leicester = create(:adviser, firm: @second, latitude: 52.633013, longitude: -1.131257)

      @excluded = create(:firm_with_no_business_split, retirement_income_products_percent: 49, other_percent: 51, other_advice_methods: other_advice_methods)
      create(:adviser, firm: @excluded, latitude: 51.428473, longitude: -0.943616)

      create(:firm_with_no_business_split, other_percent: 100, other_advice_methods: other_advice_methods) do |f|
        create(:adviser, firm: f, latitude: 51.428473, longitude: -0.943616)
      end
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

  def and_i_select_the_phone_and_or_online_advice_methods
    landing_page.remote.by_phone.set true
    landing_page.remote.online.set true
  end

  def and_i_indicate_i_need_advice_on_various_topics
    landing_page.remote.retirement_income_products.set true
    landing_page.remote.wills_and_probate.set true
  end

  def when_i_submit_the_phone_or_online_advice_search
    landing_page.remote.search.click
  end

  def then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 2)
  end

  def and_they_are_ordered_by_name
    ordered_results = [@first, @second].map(&:registered_name)

    expect(results_page.firm_names).to eql(ordered_results)
  end
end
