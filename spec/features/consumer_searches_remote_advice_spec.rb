RSpec.feature 'Consumer searches for phone or online advice' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Selecting online advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      when_i_submit_a_search_selecting_online_advice
      then_i_am_shown_firms_and_subs_that_provide_advice_online
      and_they_are_ordered_alphabetically
    end
  end

  private

  def and_firms_providing_remote_services_were_previously_indexed
    with_fresh_index! do
      @online_only      = create(:adviser, registered_name: "Abcdef")
      @online_and_phone = create(:adviser, registered_name: "Bcdefg")
      @phone_only       = create(:adviser, registered_name: "Cdefgh")
      @only_in_person   = create(:adviser, postcode: 'G1 5QT', latitude: 55.856191, longitude: -4.247082)
    end
  end

  def given_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def when_i_submit_a_search_selecting_online_advice
    landing_page.remote.tap do |section|
      section.by_phone_checkbox.click
      section.search.click
    end
  end

  def then_i_am_shown_firms_and_subs_that_provide_advice_online
    pending
    expect(results_page.firms).to be_present
  end

  def and_they_are_ordered_alphabetically
    pending
    expect(results_page.firms.map(&:name)).to contain_exactly(
      @online_only.firm.registered_name,
      @online_and_phone.firm.registered_name,
      @phone_only.firm.registered_name
    )
  end
end
