RSpec.feature 'Search for firm' do

  let!(:phone_advice)  { create(:other_advice_method, name: 'Advice by telephone', order: 1) }
	let!(:online_advice) { create(:other_advice_method, name: 'Advice online (e.g. by video call / conference / email)', order: 2) }

  let(:landing_page) { LandingPage.new }

  scenario 'search for firm by name' do
    with_elastic_search! do
			given_some_firms_were_indexed
			and_i_am_on_the_rad_landing_page
			when_i_search_for_an_existing_firm
			then_i_should_see_the_firm_in_search_results
      and_i_should_not_see_other_firms_with_dissimilar_name
		end
  end

  def given_some_firms_were_indexed
    with_fresh_index! do
      @phone_firm = create(:firm,
													 registered_name: 'The Willers Ltd',
         									 in_person_advice_methods: [],
													 other_advice_methods: [phone_advice])
      create(:adviser,
         			postcode: 'RG2 8EE',
							firm: @phone_firm,
							latitude: 51.428473,
							longitude: -0.943616)

      @online_firm = create(:firm,
														registered_name: 'The Equiters Ltd',
														in_person_advice_methods: [],
														other_advice_methods: [online_advice])
      create(:adviser,
							postcode: 'LE1 6SL',
							firm: @online_firm,
							latitude: 52.633013,
							longitude: -1.131257)

      @in_person_firm = create(:firm,
                               registered_name: 'Pall Mall Financial Services Ltd.',
                               other_advice_methods: [])
      create(:adviser,
						  postcode: 'G1 5QT',
							firm: @in_person_firm,
							latitude: 55.856191,
							longitude: -4.247082)
    end
  end

  def and_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def when_i_search_for_an_existing_firm
    landing_page.load
    landing_page.firm_search.tap do |section|
      section.firm_name_option.set true
			section.search_field.set 'Pall Mall'
		end
    landing_page.search.click
  end

	def then_i_should_see_the_firm_in_search_results
    expect(landing_page).to have_content('Pall Mall Financial Services Ltd.')
  end

  def and_i_should_not_see_other_firms_with_dissimilar_name
    expect(landing_page).not_to have_content('The Equiters Ltd')
    expect(landing_page).not_to have_content('The Willers Ltd')
  end
end
