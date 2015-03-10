RSpec.feature 'Consumer searches for phone or online advice' do
  let(:landing_page)        { LandingPage.new }
  let(:remote_results_page) { RemoteResultsPage.new }

  let!(:phone_advice)  { create(:other_advice_method, name: 'Advice by telephone', order: 1) }
  let!(:online_advice) { create(:other_advice_method, name: 'Advice online (e.g. by video call / conference / email)', order: 2) }

  scenario 'Selecting telephone advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_telephone_advice
      then_i_am_shown_firms_that_provide_advice_by_telephone
      and_they_are_ordered_alphabetically
    end
  end

  scenario 'Selecting online advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_online_advice
      then_i_am_shown_firms_that_provide_advice_online
      and_they_are_ordered_alphabetically
    end
  end

  scenario 'Selecting online and telephone advice' do
    with_elastic_search! do
      given_i_am_on_the_rad_landing_page
      and_firms_providing_remote_services_were_previously_indexed
      when_i_submit_a_search_selecting_online_and_telephone_advice
      then_i_am_shown_firms_that_provide_advice_online_and_by_telephone
      and_they_are_ordered_alphabetically
    end
  end


  def and_firms_providing_remote_services_were_previously_indexed
    with_fresh_index! do
      @online_only      = create(:firm, registered_name: 'The End Advisory',       other_advice_methods: [ online_advice ])
      @online_and_phone = create(:firm, registered_name: 'Remoteley Advisory',     other_advice_methods: [ online_advice, phone_advice ])
      @phone_only       = create(:firm, registered_name: 'Cold Callers Limited',   other_advice_methods: [ phone_advice ])
      @only_in_person   = create(:firm, registered_name: 'ACME Retirement Advice', other_advice_methods: [])
    end
  end

  def given_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def when_i_submit_a_search_selecting_online_advice
    landing_page.remote.tap do |section|
      section.online.set(true)
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_advice_online
    expect(remote_results_page.firm_names).
      to include(@online_only.registered_name, @online_and_phone.registered_name)
  end

  def and_they_are_ordered_alphabetically
    names = remote_results_page.firm_names

    expect(names).to eql(names.sort)
  end

  def when_i_submit_a_search_selecting_telephone_advice
    landing_page.remote.tap do |section|
      section.by_phone.set(true)
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_advice_by_telephone
    expect(remote_results_page.firm_names).
      to include(@phone_only.registered_name, @online_and_phone.registered_name)
  end

  def when_i_submit_a_search_selecting_online_and_telephone_advice
    landing_page.remote.tap do |section|
      section.online.set(true)
      section.by_phone.set(true)
      section.search.click
    end
  end

  def then_i_am_shown_firms_that_provide_advice_online_and_by_telephone
    expect(remote_results_page).to have_firms(count: 3)

    expect(remote_results_page.firm_names).not_to include(@only_in_person.registered_name)
  end
end
