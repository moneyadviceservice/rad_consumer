RSpec.feature 'Results page, consumer requires help with their pension over the phone or online',
              vcr: vcr_options_for_feature(:results_phone_or_online_filter_for_pension_advice) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let(:latitude) { rand(51.428473..55.856191) }
  let(:longitude) { rand(-4.247082..-0.943616) }

  scenario 'Filter for advice on a pension pot size' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_phone_or_online_advice
      and_i_need_to_speak_to_an_adviser_in_bulgarian
      when_i_submit_the_search
      then_i_am_shown_firms_that_can_advise_in_bulgarian
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
      @bulgarian_speaking_firm = create(:firm, languages: ['bul'], in_person_advice_methods: [], other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @bulgarian_speaking_firm, latitude: latitude, longitude: longitude)

      @excluded = create(:firm, languages: ['afr'], in_person_advice_methods: [], other_advice_methods: @other_advice_methods)
      create(:adviser, firm: @excluded, latitude: latitude, longitude: longitude)
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

  def and_i_need_to_speak_to_an_adviser_in_bulgarian
    results_page.search_form.languages.select 'Bulgarian'
  end

  def when_i_submit_the_search
    results_page.search_form.search.click
  end

  def then_i_am_shown_firms_that_can_advise_in_bulgarian
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 1)
    expect(results_page.firm_names).to include(@bulgarian_speaking_firm.registered_name)
  end
end
