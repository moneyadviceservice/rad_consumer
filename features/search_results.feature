Feature: Search results
  As a customer
  I want to perform all available kinds of searches

  Background: Indexed firms and advisers
    Given I have a set of indexed firms and advisers

  Scenario: Search in person advisers
    When I search for in person advisers around postcode "EC1N 2TD"
    Then I should see firms ordered by name and distance from postcode "EC1N 2TD"
      | name                     |
      | Test Firm Central London |
      | Test Firm East London    |
      | Test Firm Brighton       |
    And I should see the closest adviser to postcode "EC1N 2TD" for each result

  Scenario: Search remote firms
    When I search for remote firms
    Then I should see firms that provide remote advice in no particular order
      | name                     |
      | Test Firm Central London |
      | Test Firm East London    |
      | Test Firm Brighton       |

  Scenario: Search firm by name
    When I search for firm by name "London"
    Then I should see firms with name matching "London" ordered by name
      | name                     |
      | Test Firm Central London |
      | Test Firm East London    |

  Scenario: Search results pagination
