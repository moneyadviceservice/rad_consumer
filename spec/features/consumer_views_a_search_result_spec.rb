RSpec.feature 'Consumer views a search result',
              vcr: vcr_options_for_feature(:consumer_views_a_search_result) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  let(:principal) { create(:principal) }
  let(:firm_without_offices) do
    create(:firm_with_no_business_split,
           :without_offices,
           website_address: 'http://www.example.com',
           principal: principal,
           free_initial_meeting: true,
           minimum_fixed_fee: 1000,
           retirement_income_products_flag: true,
           pension_transfer_flag: true,
           long_term_care_flag: true,
           equity_release_flag: true,
           inheritance_tax_and_estate_planning_flag: true,
           wills_and_probate_flag: true,
           in_person_advice_methods: [1, 2].map { |i| create(:in_person_advice_method, order: i) },
           other_advice_methods: [1, 2].map { |i| create(:other_advice_method, order: i) },
           investment_sizes: [1, 2].map { |i| create(:investment_size, id: i, order: i) })
  end
  let(:firm) do
    firm_without_offices.tap { |f| create(:office, telephone_number: '02082524727', firm: f) }
  end

  scenario 'Viewing a single Firm result in English' do
    with_elastic_search! do
      given_an_indexed_firm_and_associated_adviser
      when_i_perform_a_basic_search
      then_i_see_the_indexed_firm
      and_i_see_the_firms_minimum_pot_size
      and_i_see_whether_the_firm_offers_free_initial_meetings
      and_i_see_the_qualifications_and_accreditations_the_firms_advisers_possess
    end
  end

  scenario 'Viewing a single result with no accreditations or qualifications' do
    with_elastic_search! do
      given_an_indexed_firm_and_associated_adviser_without_qualifications_and_accreditations
      when_i_perform_a_basic_search
      then_i_see_the_indexed_firm
      and_i_do_not_see_any_qualifications_and_accreditations
    end
  end

  def given_an_indexed_firm_and_associated_adviser_without_qualifications_and_accreditations
    with_fresh_index! { create_firm_and_adviser }
  end

  def given_an_indexed_firm_and_associated_adviser
    with_fresh_index! do
      create_firm_and_adviser(accreditations: [1, 2, 3], qualifications: [3, 4])
    end
  end

  def when_i_perform_a_basic_search
    landing_page.load

    landing_page.in_person.tap do |section|
      section.postcode.set 'RG2 9FL'
      section.search.click
    end
  end

  def then_i_see_the_indexed_firm
    expect(@displayed_firm = results_page.firms.first).to be
  end

  def and_i_see_the_firms_minimum_pot_size
    expect(@displayed_firm.minimum_pot_size).to match(/No minimum/)
  end

  def and_i_see_whether_the_firm_offers_free_initial_meetings
    expect(@displayed_firm).to have_free_initial_meeting
  end

  def and_i_see_the_qualifications_and_accreditations_the_firms_advisers_possess
    expect(@displayed_firm).to have_qualifications(count: 2)
    expect(@displayed_firm).to have_accreditations(count: 3)
  end

  def and_i_do_not_see_any_qualifications_and_accreditations
    expect(@displayed_firm).to_not have_qualifications
    expect(@displayed_firm).to_not have_accreditations
  end

  def create_firm_and_adviser(qualifications: [], accreditations: [])
    create(:adviser,
           firm: firm,
           latitude: 51.428473,
           longitude: -0.943616,
           accreditations: accreditations.map { |i| create(:accreditation, order: i) },
           qualifications: qualifications.map { |i| create(:qualification, order: i) }
          )
  end
end
