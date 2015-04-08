RSpec.feature 'Results page, consumer requires various types of advice over the phone or online' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Filter for various types of advice' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_and_or_online_advice_methods
      and_i_indicate_i_need_advice_on_various_topics
      when_i_submit_the_search
      then_i_am_shown_firms_that_provide_the_selected_types_of_advice
      and_they_are_ordered_by_name
    end
  end

  def given_reference_data_has_been_populated
    @other_advice_methods = [
      create(:other_advice_method, name: 'Phone', order: 1),
      create(:other_advice_method, name: 'Online', order: 2)
    ]
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @first = create(:firm_with_no_business_split, retirement_income_products_percent: 30, wills_and_probate_percent: 20, other_percent: 50, other_advice_methods: @other_advice_methods)
      @glasgow = create(:adviser, firm: @first, latitude: 55.856191, longitude: -4.247082)

      @second = create(:firm_with_no_business_split, retirement_income_products_percent: 29, wills_and_probate_percent: 20, other_percent: 51, other_advice_methods: @other_advice_methods)
      @leicester = create(:adviser, firm: @second, latitude: 52.633013, longitude: -1.131257)

      @excluded = create(:firm_with_no_business_split, retirement_income_products_percent: 49, other_percent: 51, other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @excluded, latitude: 51.428473, longitude: -0.943616)

      create(:firm_with_no_business_split, other_percent: 100, other_advice_methods: @other_advice_methods) do |f|
        create(:adviser, firm: f, latitude: 51.428473, longitude: -0.943616)
      end
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
      f.phone.set false
      f.online.set false

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

  def and_i_select_the_phone_and_or_online_advice_methods
    results_page.search_form.phone.set true
    results_page.search_form.online.set true
  end

  def and_i_indicate_i_need_advice_on_various_topics
    results_page.search_form.retirement_income_products.set true
    results_page.search_form.wills_and_probate.set true
  end

  def when_i_submit_the_search
    results_page.search_form.search.click
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
