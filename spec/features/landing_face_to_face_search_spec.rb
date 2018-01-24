RSpec.feature 'Landing page, consumer requires general advice in person',
              vcr: vcr_options_for_feature(:landing_face_to_face_search) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:phone_advice) { create(:other_advice_method, name: 'Advice by telephone', order: 1) }

  scenario 'Using a valid postcode' do
    with_elastic_search! do
      given_i_am_on_the_landing_page
      and_firms_with_advisers_covering_my_postcode_were_previously_indexed
      when_i_search_with_a_reading_postcode
      then_i_am_shown_firms_with_advisers_covering_my_postcode
      and_i_am_not_shown_non_postcode_searchable_firms
      and_the_firms_are_ordered_by_distance_and_name
    end
  end

  scenario 'Using an invalid postcode' do
    given_i_am_on_the_landing_page
    when_i_submit_a_invalid_postcode_search
    then_i_am_told_the_postcode_is_incorrect
  end

  scenario 'Using a postcode that cannot be geocoded' do
    given_i_am_on_the_landing_page
    when_i_submit_a_postcode_that_cannot_be_geocoded
    then_i_am_told_the_postcode_is_incorrect
  end

  scenario 'Paginating through 21 results' do
    with_elastic_search! do
      given_i_am_on_the_landing_page
      and_multiple_firms_were_created_and_indexed
      when_i_search_with_a_reading_postcode
      then_i_see_ten_results
      and_i_see_i_am_viewing_firms_one_to_ten_of_twenty_one
      when_i_click_next
      then_i_see_i_am_viewing_firms_eleven_to_twenty_of_twenty_one
    end
  end

  def given_i_am_on_the_landing_page
    landing_page.load
  end

  def and_multiple_firms_were_created_and_indexed
    with_fresh_index! do
      create_list(:adviser, 21, latitude: 51.428473, longitude: -0.943616)
    end
  end

  def then_i_see_ten_results
    expect(results_page.firms.count).to eq(10)
  end

  def and_i_see_i_am_viewing_firms_one_to_ten_of_twenty_one
    expect(results_page).to be_showing_firms(1, to: 10, of: 21)
  end

  def when_i_click_next
    results_page.next_page
  end

  def then_i_see_i_am_viewing_firms_eleven_to_twenty_of_twenty_one
    expect(results_page).to be_showing_firms(11, to: 20, of: 21)
  end

  def and_firms_with_advisers_covering_my_postcode_were_previously_indexed
    with_fresh_index! do
      @second = create(:adviser,
                       firm: create(:firm, registered_name: 'ZZZ'),
                       postcode: 'RG2 8EE',
                       latitude: 51.428473,
                       longitude: -0.943616,
                       travel_distance: 100)

      @first = create(:adviser,
                      firm: create(:firm, registered_name: 'AAA'),
                      postcode: 'RG2 8EE',
                      latitude: 51.428473,
                      longitude: -0.943616,
                      travel_distance: 100)

      @leicester = create(:adviser, postcode: 'LE1 6SL', latitude: 52.633013, longitude: -1.131257, travel_distance: 650)
      @glasgow   = create(:adviser, postcode: 'G1 5QT', latitude: 55.856191, longitude: -4.247082, travel_distance: 10)

      @missing = create(:firm, in_person_advice_methods: [], other_advice_methods: [phone_advice]) do |firm|
        create(:adviser, firm: firm, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def when_i_search_with_a_reading_postcode
    landing_page.in_person.tap do |section|
      section.face_to_face.set true
      section.postcode.set 'RG2 9FL'
      section.search.click
    end
  end

  def then_i_am_shown_firms_with_advisers_covering_my_postcode
    expect(results_page.firms).to be_present
  end

  def and_i_am_not_shown_non_postcode_searchable_firms
    expect(
      results_page.firm_names
    ).to_not include(@missing.registered_name)
  end

  def and_the_firms_are_ordered_by_distance_and_name
    expect(results_page.firm_names).to eql([
                                             @first.firm.registered_name,
                                             @second.firm.registered_name,
                                             @leicester.firm.registered_name
                                           ])
  end

  def when_i_submit_a_invalid_postcode_search
    landing_page.in_person.tap do |section|
      section.face_to_face.set true
      section.postcode.set 'Z'
      section.search.click
    end
  end

  def when_i_submit_a_postcode_that_cannot_be_geocoded
    landing_page.in_person.tap do |section|
      section.face_to_face.set true
      section.postcode.set 'ZZ1 1ZZ'
      section.search.click
    end
  end

  def then_i_am_told_the_postcode_is_incorrect
    expect(landing_page.in_person).to be_invalid_postcode
  end
end
