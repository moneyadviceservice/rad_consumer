RSpec.feature 'Results page, consumer requires various types of advice over the phone or online',
              vcr: vcr_options_for_feature(:results_phone_or_online_filter_for_other_advice_types) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Filter for various types of advice' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_indicate_i_need_advice_on_various_topics
      when_i_submit_the_search
      then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    end
  end

  def given_reference_data_has_been_populated
    @other_advice_methods = [
      create(:other_advice_method, name: 'Phone', order: 1),
      create(:other_advice_method, name: 'Online', order: 2)
    ]

    @in_person_advice_methods = create_list(:in_person_advice_method, 3)
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @both_services = create(:firm, ethical_investing_flag: true, sharia_investing_flag: true, registered_name: 'first', in_person_advice_methods: [], other_advice_methods: @other_advice_methods)
      @leicester = create(:adviser, firm: @both_services, latitude: 52.633013, longitude: -1.131257)

      @ethical_service = create(:firm, ethical_investing_flag: true, sharia_investing_flag: false, registered_name: 'second', in_person_advice_methods: [], other_advice_methods: @other_advice_methods)
      @glasgow = create(:adviser, firm: @ethical_service, latitude: 55.856191, longitude: -4.247082)

      @sharia_service = create(:firm, ethical_investing_flag: false, sharia_investing_flag: true, registered_name: 'third', in_person_advice_methods: [], other_advice_methods: @other_advice_methods)
      @glasgow = create(:adviser, firm: @ethical_service, latitude: 55.856191, longitude: -4.247082)

      @no_service = create(:firm, ethical_investing_flag: false, sharia_investing_flag: false, registered_name: 'exluded', in_person_advice_methods: [], other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @no_service, latitude: 51.428473, longitude: -0.943616)
    end
  end

  def and_i_am_on_the_results_page_after_a_previous_search
    landing_page.load
    landing_page.in_person.tap do |f|
      f.postcode.set 'RG2 9FL'
      f.search.click
    end

    expect(results_page).to be_displayed
  end

  def and_i_clear_any_filters_from_the_previous_search
    results_page.search_form.tap do |f|
      f.face_to_face.set false
      f.phone_or_online.set false

      f.postcode.set nil

      f.retirement_income_products.set false
      f.pension_pot_size.set SearchForm::ANY_SIZE_VALUE
      f.pension_transfer.set false
      f.options_when_paying_for_care.set false
      f.equity_release.set false
      f.inheritance_tax_planning.set false
      f.wills_and_probate.set false
    end
  end

  def and_i_select_phone_or_online_advice
    results_page.search_form.phone_or_online.set true
  end

  def and_i_indicate_i_need_advice_on_various_topics
    results_page.search_form.ethical_investing.set true
    results_page.search_form.sharia_investing.set true
  end

  def when_i_submit_the_search
    results_page.search_form.search.click
  end

  def then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    expect(results_page).to be_displayed
    expect(results_page.firms.length).to eql(1)

    expect(results_page.firm_names.first).to eql(@both_services.registered_name)
  end
end
