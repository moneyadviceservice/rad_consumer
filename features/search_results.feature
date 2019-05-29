Feature: Search results
  As a customer
  I want to perform all available kinds of searches

  Scenario: Search in person advisers
    When I am performing the "in person" search with value "EC1N 2TD"
    Then I should see firms ordered by name and closest adviser distance
      | name                     | distance |
      | Test Firm Central London | 0.0      |
      | Test Firm East London    | 2.4      |
      | Test Firm Brighton       | 47.8     |
    And I should see the following firm details
      | name                     | offices | advisers | link                          |
      | Test Firm Central London | 2       | 2        | /en/firms/1?postcode=EC1N+2TD |
      | Test Firm East London    | 1       | 2        | /en/firms/2?postcode=EC1N+2TD |
      | Test Firm Brighton       | 0       | 1        | /en/firms/3?postcode=EC1N+2TD |
    And The order does not change with a few page reloads

  Scenario: Search remote firms
    When I am performing the "phone or online" search
    Then I should see the following firms in no particular order
      | name               |
      | Test Firm Remote 2 |
      | Test Firm Remote 1 |
      | Test Firm Remote 3 |
    And I should see the following firm details
      | name               | link        |
      | Test Firm Remote 2 | /en/firms/5 |
      | Test Firm Remote 1 | /en/firms/4 |
      | Test Firm Remote 3 | /en/firms/6 |
    And The order does not change with a few page reloads

  Scenario: Search firm by name
    When I am performing the "firm by name" search with value "London"
    Then I should see the following firms in no particular order
      | name                     |
      | Test Firm Central London |
      | Test Firm East London    |
    And I should see the following firm details
      | name                     | link        |
      | Test Firm Central London | /en/firms/1 |
      | Test Firm East London    | /en/firms/2 |
    And The order does not change with a few page reloads

  Scenario: Search results pagination
