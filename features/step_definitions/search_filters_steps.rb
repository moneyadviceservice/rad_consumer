When('I check the options') do |table|
  options = table.rows.flatten
  options.each do |option|
    @results_page.search_form.public_send(option.parameterize.underscore).click
  end
  @results_page.search_form.search.click
  init_results_page
end

When('I choose the investment size {string}') do |investment_size|
  @results_page.search_form.investment_sizes.select(investment_size)
  @results_page.search_form.search.click
  init_results_page
end

When('I choose the accreditation / qualification {string}') do |option|
  @results_page.search_form.accreditation_or_qualification.select(option)
  @results_page.search_form.search.click
  init_results_page
end

When('I choose the language {string}') do |language|
  @results_page.search_form.languages.select(language)
  @results_page.search_form.search.click
  init_results_page
end

Then('I should see the following firms') do |table|
  expected_firms = table.rows.flatten

  expect(@firm_names).to match_array(expected_firms)
end
