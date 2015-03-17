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


  def given_an_indexed_firm_and_associated_adviser
    with_fresh_index! do
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
        other_percent: 40
      )

      create(:adviser, firm: @firm, latitude: 51.428473, longitude: -0.943616)
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
  end

  def and_i_see_the_types_of_advice_the_firm_offers
  end

  def and_i_see_the_firms_minimum_pot_size
  end

  def and_i_see_the_firms_minimum_fee
  end

  def and_i_see_whether_the_firm_offers_free_initial_meetings
  end

  def and_i_see_the_qualifications_and_accreditations_the_firms_advisers_possess
  end
end
