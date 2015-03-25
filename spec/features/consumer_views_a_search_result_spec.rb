RSpec.feature 'Consumer views a search result' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Viewing a single Firm result in English' do
    with_elastic_search! do
      given_an_indexed_firm_and_associated_adviser
      when_i_perform_a_basic_search
      then_i_see_the_indexed_firm
      and_i_see_the_firms_contact_details
      and_i_see_the_where_the_firm_offers_advice
      and_i_see_the_types_of_advice_the_firm_offers
      and_i_see_the_firms_minimum_pot_size
      and_i_see_the_firms_minimum_fee
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
      and_i_do_not_see_the_label
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

  def and_i_see_the_firms_contact_details
    expect(@displayed_firm.address_line_one).to eq(@firm.address_line_one)
    expect(@displayed_firm.address_town).to eq(@firm.address_town)
    expect(@displayed_firm.address_county).to eq(@firm.address_county)
    expect(@displayed_firm.address_postcode).to eq(@firm.address_postcode)

    expect(@displayed_firm.telephone_number).to eq(@firm.telephone_number)
    expect(@displayed_firm.website_address).to be
    expect(@displayed_firm.email_address).to be
  end

  def and_i_see_the_where_the_firm_offers_advice
    expect(@displayed_firm).to have_in_person_advice_methods(count: 2)
    expect(@displayed_firm).to have_other_advice_methods(count: 2)
  end

  def and_i_see_the_types_of_advice_the_firm_offers
    expect(@displayed_firm).to have_types_of_advice(count: 6)
  end

  def and_i_see_the_firms_minimum_pot_size
    expect(@displayed_firm.minimum_pot_size).to eq('Under £50,000')
  end

  def and_i_see_the_firms_minimum_fee
    expect(@displayed_firm.minimum_fixed_fee).to eq('£1,000')
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

  def and_i_do_not_see_the_label
    expect(@displayed_firm).to_not have_qualifications_heading
  end

  def create_firm_and_adviser(qualifications: [], accreditations: [])
    @principal = create(:principal, website_address: 'http://www.example.com')

    @firm = create(:firm_with_no_business_split,
      principal: @principal,
      free_initial_meeting: true,
      minimum_fixed_fee: 1000,
      retirement_income_products_percent: 10,
      pension_transfer_percent: 10,
      long_term_care_percent: 10,
      equity_release_percent: 10,
      inheritance_tax_and_estate_planning_percent: 10,
      wills_and_probate_percent: 10,
      other_percent: 40,
      in_person_advice_methods: [1, 2].map { |i| create(:in_person_advice_method, order: i) },
      other_advice_methods: [1, 2].map { |i| create(:other_advice_method, order: i) },
      investment_sizes: [1, 2].map { |i| create(:investment_size, order: i) }
    )

    create(:adviser,
      firm: @firm,
      latitude: 51.428473,
      longitude: -0.943616,
      accreditations: accreditations.map { |i| create(:accreditation, order: i) },
      qualifications: qualifications.map { |i| create(:qualification, order: i) }
    )
  end
end
