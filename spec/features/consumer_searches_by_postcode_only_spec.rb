RSpec.feature 'Consumer searches by postcode only' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Consumer enters a invalid postcode' do
    given_i_am_on_the_rad_landing_page
    when_i_submit_a_invalid_postcode_search
    then_i_am_told_the_postcode_is_incorrect
  end

  scenario 'Postcode cannot be geocoded' do
    VCR.use_cassette(:postcode_cannot_be_geocoded) do
      given_i_am_on_the_rad_landing_page
      when_i_submit_a_postcode_that_cannot_be_geocoded
      then_i_am_told_the_postcode_is_incorrect
    end
  end

  scenario 'Consumer enters a valid postcode' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_with_advisers_covering_my_postcode_were_previously_indexed
      when_i_search_with_a_reading_postcode
      then_i_am_shown_firms_with_advisers_covering_my_postcode
      and_i_am_not_shown_non_postcode_searchable_firms
      and_the_firms_are_ordered_by_distance_in_miles_to_me
    end
  end


  def given_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def and_firms_with_advisers_covering_my_postcode_were_previously_indexed
    with_fresh_index! do
      @reading   = create(:adviser, postcode: 'RG2 8EE', latitude: 51.428473, longitude: -0.943616)
      @leicester = create(:adviser, postcode: 'LE1 6SL', latitude: 52.633013, longitude: -1.131257)
      @glasgow   = create(:adviser, postcode: 'G1 5QT', latitude: 55.856191, longitude: -4.247082)

      @missing = create(:firm, in_person_advice_methods: []) do |firm|
        create(:adviser, firm: firm, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def when_i_search_with_a_reading_postcode
    landing_page.in_person.tap do |section|
      section.postcode.set 'RG2 9FL'
      section.search.click
    end
  end

  def then_i_am_shown_firms_with_advisers_covering_my_postcode
    expect(results_page.firms).to be_present
  end

  def and_i_am_not_shown_non_postcode_searchable_firms
    expect(
      results_page.firms.map(&:name)
    ).to_not include(@missing.registered_name)
  end

  def and_the_firms_are_ordered_by_distance_in_miles_to_me
    expect(results_page.firms.map(&:name)).to contain_exactly(
      @reading.firm.registered_name,
      @leicester.firm.registered_name,
      @glasgow.firm.registered_name
    )
  end

  def when_i_submit_a_invalid_postcode_search
    landing_page.in_person.tap do |section|
      section.postcode.set 'B4D'
      section.search.click
    end
  end

  def when_i_submit_a_postcode_that_cannot_be_geocoded
    landing_page.in_person.tap do |section|
      section.postcode.set 'ZZ1 1ZZ'
      section.search.click
    end
  end

  def then_i_am_told_the_postcode_is_incorrect
    expect(landing_page.in_person).to be_invalid_postcode
  end

  def with_fresh_index!
    `curl -XDELETE -sS http://127.0.0.1:9200/rad_test`
    `curl -XPOST -sS http://127.0.0.1:9200/rad_test -d @elastic_search_mapping.json`
    yield
    `curl -XPOST -sS http://127.0.0.1:9200/rad_test/_refresh`
  end

  def with_elastic_search!
    VCR.turned_off do
      begin
        WebMock.allow_net_connect!
        yield
      ensure
        WebMock.disable_net_connect!
      end
    end
  end
end
