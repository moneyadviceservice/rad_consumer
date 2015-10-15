RSpec.feature 'Consumer filters results based on qualifications and accreditations',
              vcr: vcr_options_for_feature(:qualifications_and_accreditations_filters_on_results_list) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }
  let(:postcode) { 'EH3 9DR' }
  let(:select_prompt) { I18n.t('search.filter.select_prompt') }

  #
  # Create fixture records
  #
  # A record must exist for each option that will appear in the filter.
  # The record name fields do not matter as the filter names are populated from
  # the locale file.
  # Mapping from record to enabled filter option is done via the 'order' field
  # rather than by database id, which may vary
  # Creating 10 of each type to ensure we definitely have more than the subset
  # that will be enabled.
  let(:qualifications) { FactoryGirl.create_list(:qualification, 10) }
  let(:accreditations) { FactoryGirl.create_list(:accreditation, 10) }

  #
  # Provide a way to lookup record by a given order number
  #
  let(:ord_to_qualification) { map_order_to_object(qualifications) }
  let(:ord_to_accreditation) { map_order_to_object(accreditations) }

  #
  # Load the real set of enabled filter options
  #
  let(:enabled_qualification_opts) { enabled_options_for(Qualification) }
  let(:enabled_accreditation_opts) { enabled_options_for(Accreditation) }
  let(:enabled_option_names) { enabled_qualification_opts.map(&:name) + enabled_accreditation_opts.map(&:name) }

  #
  # Bookmark specific filters to use in the test, so we don't have to rely on
  # hardcoded numbers
  #
  let(:qual_a) { enabled_qualification_opts[0] }
  let(:qual_b) { enabled_qualification_opts[1] }
  let(:accr_a) { enabled_accreditation_opts[0] }
  let(:accr_b) { enabled_accreditation_opts[1] }
  let(:accr_c) { enabled_accreditation_opts[2] }
  let(:no_selection) { FilterOption.new(nil, select_prompt) }

  #
  # Construct the firm and adviser fixtures
  #
  let(:firm_1) do
    FactoryGirl.create(:firm_without_advisers) do |f|
      create_adviser(f, postcode, qualifications: [qual_a, qual_b], accreditations: [accr_a])
    end
  end
  let(:firm_2) do
    FactoryGirl.create(:firm_without_advisers) do |f|
      create_adviser(f, postcode, qualifications: [qual_a], accreditations: [accr_b])
    end
  end
  let(:firms) { [firm_1, firm_2] }

  scenario 'Filtering results based on qualifications and accreditations' do
    with_elastic_search! do
      given_some_firms_were_indexed

      when_i_am_on_the_search_results_page
      then_i_see_all_results
      then_i_see_all_expected_filter_options

      when_i_filter_the_results_by(qual_b)
      then_the_results_are([firm_1])

      when_i_filter_the_results_by(qual_a)
      then_the_results_are([firm_1, firm_2])

      when_i_filter_the_results_by(accr_b)
      then_the_results_are([firm_2])

      when_i_filter_the_results_by(accr_c)
      then_the_results_are([])

      when_i_filter_the_results_by(no_selection)
      then_the_results_are([firm_1, firm_2])
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

    results_page.wait_for_firms
  end

  def then_i_see_all_results
    expect(results_page).to be_displayed
    expect_no_errors_on(results_page)
    expect(results_page.firms.count).to eq(firms.count)
  end

  def then_i_see_all_expected_filter_options
    results_page.search_form.qualifications_and_accreditations_option_names.tap do |opts|
      expect(opts.first).to eq(select_prompt)
      expect(opts[1..-1]).to match_array(enabled_option_names)
    end
  end

  def when_i_filter_the_results_by(option)
    results_page.search_form.tap do |section|
      section.qualifications_and_accreditations.select(option.name)
      section.search.click
    end

    results_page.wait_for_firms
  end

  def then_the_results_are(expected_results)
    expect_no_errors_on(results_page)
    expect(results_page.firms.count).to eq(expected_results.count)
    expected_names = expected_results.map(&:registered_name)
    expect(results_page.firm_names).to match_array(expected_names)
  end

  private

  FilterOption = Struct.new(:order, :name)

  def enabled_options_for(model)
    to_obj = -> (k, v) { FilterOption.new(k.to_s.to_i, v) }
    I18n.t("search.filter.#{model.model_name.i18n_key}.ordinal").map(&to_obj)
  end

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
           accreditations: accreditations.map { |opt| ord_to_accreditation[opt.order] },
           qualifications: qualifications.map { |opt| ord_to_qualification[opt.order] }
          )
  end
end
