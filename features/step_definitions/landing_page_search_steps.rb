Then("I am redirected to the results page") do
  @results_page = SearchResultsPage.new
  expect(@results_page).to be_displayed
end

Then(/^I can see the (.*) option checked\s?(?:with value (.*))?$/) do |option, value|
  form = @results_page.search_form

  case option
  when 'in person'
    expect(form.in_person_search_option).to be_selected
    expect(form.postcode.value).to eq(value)
  when 'phone or online'
    expect(form.phone_or_online_search_option).to be_selected
  when 'firm by name'
    expect(form.firm_by_name_search_option).to be_selected
    expect(form.firm_name_field.value).to eq(value)
  end
end
