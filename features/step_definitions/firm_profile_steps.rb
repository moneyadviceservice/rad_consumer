When("I am viewing the profile for firm {string}") do |name|
  steps %{
    When I am performing the "firm by name" search with value \"#{name}\"
  }
  firm = @firms.find { |firm| firm.name == name }
  firm.view_profile.click
  init_profile_page
end

def init_profile_page
  @profile_page = ProfilePage.new
end

Then("I can see the following general information") do |table|
  headers = table.raw.first
  expected = table.rows.flatten

  headers.each_with_index do |header, i|
    subject = @profile_page.public_send(header.to_sym)
    subject = subject.text if subject.respond_to?(:text)
    expect(subject).to eq(expected[i])
  end
end

Then("I can see the following details") do |table|
  callout = @profile_page.callout

  table.rows.each do |row|
    element = row[0]
    expected = row[1]
    subject = callout.public_send(element.parameterize.underscore.to_sym)
    subject = subject.text if subject.respond_to?(:text)
    expect(subject).to include(expected)
  end
end

Then("I can see the following firm services") do |table|
  services = @profile_page.services.map(&:text)
  expected = table.rows.flatten

  services.each_with_index do |service, i|
    expect(service).to eq(expected[i])
  end

  expect(services.count).to eq(expected.count)
end

Then("I can see the following remote advice methods") do |table|
  advice_methods = @profile_page.advice_methods.map(&:text)
  expected = table.rows.flatten

  advice_methods.each_with_index do |advice_method, i|
    expect(advice_method).to eq(expected[i])
  end

  expect(advice_methods.count).to eq(expected.count)
end

When("I click on the {string} tab") do |name|
  @profile_page.public_send(:"#{name}_tab").click
end

Then(/^I can see the following offices/) do |table|
  headers = table.raw.first
  offices = @profile_page.offices
  expected = table.rows

  offices.each_with_index do |office, i|
    headers.each_with_index do |header, j|
      subject = office.public_send(header.to_sym)
      subject = subject.text if subject.respond_to?(:text)
      expect(subject).to eq(expected[i][j])
    end
  end

  expect(offices.count).to eq(expected.size)
end

Then(/^I can see the following advisers/) do |table|
  headers = table.raw.first
  advisers = @profile_page.advisers
  expected = table.rows

  advisers.each_with_index do |adviser, i|
    headers.each_with_index do |header, j|
      subject = adviser.public_send(header.to_sym)
      subject = subject.text if subject.respond_to?(:text)
      expect(subject).to eq(expected[i][j])
    end
  end

  expect(advisers.count).to eq(expected.size)
end

When("I open the profile of firm {string} from the results") do |name|
  firm = @results_page.firms.find { |firm| firm.name == name }
  firm.view_profile.click
  init_profile_page
end

Then("I can see the closest adviser {string} miles away") do |expected|
  regex = /has an adviser (\d+.\d+) miles away/
  message = @profile_page.nearest_adviser_distance.text
  distance = message.match(regex).captures.first

  expect(distance).to eq(expected)
end

When("I can see the list of the previously viewed firms") do |table|
  recently_viewed_firms = @profile_page.recently_viewed_firms.map(&:text)
  expected_names = table.rows.flatten

  expect(recently_viewed_firms).to eq(expected_names)
end
