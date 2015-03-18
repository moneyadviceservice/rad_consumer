RSpec.feature 'Consumer requires advice on various topics' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Filter for various types of advice' do
    with_elastic_search! do
      given_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_landing_page
      and_i_select_face_to_face_advice
      and_i_enter_a_valid_postcode
      and_i_indicate_i_need_advice_on_various_topics
      when_i_submit_the_face_to_face_advice_search
      then_i_am_shown_firms_that_provide_the_selected_types_of_advice
      and_they_are_ordered_by_business_split_and_location
    end
  end

  def given_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @first = create(:firm_with_no_business_split,
        retirement_income_products_percent: 30,
        wills_and_probate_percent: 20,
        other_percent: 50
      ) do |f|
        @glasgow = create(:adviser, firm: f, latitude: 55.856191, longitude: -4.247082)
      end

      @second = create(:firm_with_no_business_split,
        retirement_income_products_percent: 29,
        wills_and_probate_percent: 20,
        other_percent: 51
      ) do |f|
        @leicester = create(:adviser, firm: f, latitude: 52.633013, longitude: -1.131257)
      end

      create(:firm_with_no_business_split,
        retirement_income_products_percent: 49,
        other_percent: 51
      ) do |f|
        create(:adviser, firm: f, latitude: 51.428473, longitude: -0.943616)
      end

      create(:firm_with_no_business_split,
        other_percent: 100
      ) do |f|
        create(:adviser, firm: f, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def and_i_am_on_the_landing_page
    landing_page.load
  end

  def and_i_select_face_to_face_advice
    # This is here to help make the feature steps read easier, but also
    # serves as a place-holder for when the search form markup becomes
    # one form and requires the advice method to be selected.
  end

  def and_i_enter_a_valid_postcode
    landing_page.in_person.postcode.set 'RG2 9FL'
  end

  def and_i_indicate_i_need_advice_on_various_topics
    landing_page.in_person.pension_pot.set true
    landing_page.in_person.wills_and_probate.set true
  end

  def when_i_submit_the_face_to_face_advice_search
    landing_page.in_person.search.click
  end

  def then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 2)
  end

  def and_they_are_ordered_by_business_split_and_location
    ordered_results = [@first, @second].map(&:registered_name)

    expect(results_page.firm_names).to eql(ordered_results)
  end
end
