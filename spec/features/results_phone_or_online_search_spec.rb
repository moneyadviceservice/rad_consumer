RSpec.feature 'Results page, consumer requires general advice over the phone or online',
              vcr: vcr_options_for_feature(:results_phone_or_online_search) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Using only the phone advice method' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_select_the_phone_advice_method
      when_i_submit_the_search
      then_i_see_firms_that_provide_advice_over_the_phone
    end
  end

  scenario 'Using only the online advice method' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_select_the_online_advice_method
      when_i_submit_the_search
      then_i_see_firms_that_provide_advice_online
    end
  end

  scenario 'Using both the phone and online advice methods' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_select_both_the_phone_and_online_advice_methods
      when_i_submit_the_search
      then_i_see_firms_that_provide_advice_over_the_phone_or_online
    end
  end

  scenario 'Using no advice method' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      when_i_submit_the_search
      then_i_see_an_error_message
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
      @phone_firm = create(:firm, other_advice_methods: [@other_advice_methods.first])
      create(:adviser, firm: @phone_firm)

      @online_firm = create(:firm, other_advice_methods: [@other_advice_methods.second])
      create(:adviser, firm: @online_firm)

      @excluded = create(:firm, other_advice_methods: [])
      create(:adviser, firm: @excluded)
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

  def and_i_select_the_phone_advice_method
    results_page.search_form.phone.set true
  end

  def and_i_select_the_online_advice_method
    results_page.search_form.online.set true
  end

  def and_i_select_both_the_phone_and_online_advice_methods
    results_page.search_form.phone.set true
    results_page.search_form.online.set true
  end

  def when_i_submit_the_search
    results_page.search_form.search.click
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
