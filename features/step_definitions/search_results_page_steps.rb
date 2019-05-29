Then("I should see firms ordered by name and closest adviser distance") do |table|
  messages = @firms.map(&:distance_to_the_nearest_adviser_message)
  regex = /has an adviser (\d+.\d+) miles away/

  expected_firms = table.rows
  expected_firms.each_with_index do |row, i|
    name = @firm_names[i]
    distance = messages[i].match(regex).captures.first

    expect(name).to eq(row[0])
    expect(distance).to eq(row[1])
  end

  expect(@firms.count).to eq(expected_firms.count)
end

Then("I should see the following firm details") do |table|
  headers = table.raw.first
  mapped_rows = map_firm_details(headers, table.rows)

  @firms.each do |firm|
    expected = mapped_rows[firm.name]

    if %w[offices advisers].in?(headers)
      regex = /Firm has (\d+) offices? and (\d+) advisers?/
      message = firm.number_of_offices_and_advisers_message
      offices, advisers = message.match(regex).captures

      expect(offices).to eq(expected['offices'])
      expect(advisers).to eq(expected['advisers'])
    end

    expect(firm.view_profile['href']).to eq(expected['link'])
  end
end

Then("I should see the following firms in no particular order") do |table|
  expected_firms = table.rows.flatten

  expect(@firm_names).to match_array(expected_firms)
end

Then("The order does not change with a few page reloads") do
  3.times do
    visit(current_uri)
    init_results_page

    expect(@firm_names).to eq(@last_ordered_firms)
  end
end

def map_firm_details(headers, rows)
  rows.reduce({}) do |acc, rows|
    name = rows[0]
    values = headers.inject({}) do |headers, header|
      headers.merge(header => rows[headers.size])
    end
    acc.merge(name => values)
  end
end