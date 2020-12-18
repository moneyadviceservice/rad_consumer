When("I visit the landing page") do
  @landing_page = LandingPage.new
  @landing_page.load
end

When(/^I am performing the "(.*)" search\s?(?:with value "(.*)")?$/) do |option, value|
  steps %{
    When I visit the landing page
    And I choose the "#{option}" search option #{value && "with value \"#{value}\""}
  }
  init_results_page
end

And(/^I choose the "(.*)" search option\s?(?:with value "(.*)")?$/) do |option, value|
  form = @landing_page.search_form

  case option
  when 'in person'
    form.in_person_search_option.click
    form.postcode_field.set(value)
  when 'phone or online'
    form.phone_or_online_search_option.click
  when 'firm by name'
    form.firm_by_name_search_option.click
    form.firm_name_field.set(value)
  end

  form.search.click
end

def init_results_page
  @results_page = SearchResultsPage.new
  @firms = @results_page.firms
  @firm_names = @firms.map(&:name)
  @last_ordered_firms = @firm_names
end
