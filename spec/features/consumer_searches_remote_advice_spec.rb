RSpec.feature 'Consumer searches for phone or online advice' do
  let(:landing_page)        { LandingPage.new }
  let(:remote_results_page) { RemoteResultsPage.new }

  let(:online_advice) { create :other_advice_method, name: "Advice online (e.g. by video call / conference / email)" }
  let(:phone_advice)  { create :other_advice_method, name: "Advice by telephone" }

  scenario 'Selecting online advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_online_advice
      then_i_am_shown_firms_and_subs_that_provide_advice_online
      and_they_are_ordered_alphabetically
    end
  end

  private

  def and_firms_providing_remote_services_were_previously_indexed
    with_fresh_index! do
      @online_only      = create(:firm, other_advice_methods: [ online_advice ])
      @online_and_phone = create(:firm, other_advice_methods: [ online_advice, phone_advice ])
      @phone_only       = create(:firm, other_advice_methods: [ phone_advice ])
      @only_in_person   = create(:firm, other_advice_methods: [])

      @companies = [ @online_only, @online_and_phone, @phone_only, @only_in_person ]
      @companies.each { |c| IndexFirmJob.perform_later(c) }
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
    expect(remote_results_page.firms).to be_present
  end

  def and_they_are_ordered_alphabetically
    expect(remote_results_page.firms.map(&:name)).to contain_exactly(
      @online_only.registered_name,
      @online_and_phone.registered_name,
      @phone_only.registered_name
    )
  end
end
