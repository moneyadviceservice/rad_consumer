RSpec.feature 'Consumer filters results based on qualifications and accreditations',
              vcr: vcr_options_for_feature(:qualifications_and_accreditations_filters_on_results_list) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:postcode) { 'EH3 9DR' }

  let(:qualifications) { FactoryGirl.create_list(:qualification, 3) }
  let(:accreditations) { FactoryGirl.create_list(:accreditation, 3) }
  let(:ord_to_qualification) { map_order_to_object(qualifications) }
  let(:ord_to_accreditation) { map_order_to_object(accreditations) }

  let(:firm_1) do
    FactoryGirl.create(:firm_without_advisers) do |f|
      create_adviser(f, postcode, qualifications: [1, 2], accreditations: [1, 2])
    end
  end
  let(:firm_2) do
    FactoryGirl.create(:firm_without_advisers) do |f|
      create_adviser(f, postcode, qualifications: [1, 3], accreditations: [1, 3])
    end
  end
  let(:firms) { [firm_1, firm_2] }

  scenario 'Filtering results based on qualifications and accreditations' do
    with_elastic_search! do
      given_some_firms_were_indexed

      when_i_am_on_the_search_results_page
      then_i_see_all_results

      when_i_filter_the_results_by(ord_to_qualification[2])
      then_the_results_are([firm_1])
      # then_previously_selected_filters_are_preserved_for(qualifications, accreditations)
    end
  end

  def given_some_firms_were_indexed
    with_fresh_index! { firms }
  end

  def when_i_am_on_the_search_results_page
    landing_page.load

    landing_page.in_person.tap do |section|
      section.postcode.set postcode
      section.search.click
    end
  end

  def then_i_see_all_results
    expect(results_page).to be_displayed
    expect_no_errors_on(results_page)
    expect(results_page.firms.count).to eq(firms.count)
  end

  def when_i_filter_the_results_by(qual_or_accred)
    # XXX friendly_name or id? Or something else?
    results_page.search_form.qualifications_and_accreditations.set(qual_or_accred.friendly_name)
  end

  def then_the_results_are(expected_results)
    expect(results_page.firms.count).to eq(expected_results.count)
    expected_names = expected_results.map(&:registered_name)
    expect(results_page.firm_names).to match_array(expected_names)
  end

  # def then_previously_selected_filters_are_preserved_for(qualifications, accreditations)
  # end

  private

  def expect_no_errors_on(the_page)
    expect(the_page).not_to have_text %r{Error|[Ww]arn|[Ee]xception}
    expect(the_page.status_code).not_to eq(500)
  end

  def map_order_to_object(collection)
    collection.each_with_object({}) { |o, h| h[o.order] = o }
  end

  def create_adviser(firm, postcode, qualifications: [], accreditations: [])
    create(:adviser,
           firm: firm,
           postcode: postcode,
           latitude: 55.9469408,
           longitude: -3.2017516,
           accreditations: accreditations.map { |i| ord_to_accreditation[i] },
           qualifications: qualifications.map { |i| ord_to_qualification[i] }
          )
  end
end
