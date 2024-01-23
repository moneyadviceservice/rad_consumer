Feature: Search filters
  As a customer
  I want to filter my search

  Scenario: Filter by type of advice
    When I am performing the "phone or online" search
    And I check the options
      | name                                       |
      | Pension pot / Other savings or investments |
      | Equity release                             |
    Then I should see the following firms
      | name               |
      | Test Firm Remote 1 |
      | Test Firm Remote 2 |

  Scenario: Filter by pension pot or investment size
    When I am performing the "firm by name" search with value "Test Firm"
    And I choose the investment size "£50,000"
    Then I should see the following firms
      | name                  |
      | Test Firm Remote 2    |
      | Test Firm East London |

  Scenario: Filter by adviser spoken language
    When I am performing the "firm by name" search with value "Test Firm"
    And I choose the language "Italian"
    Then I should see the following firms
      | name                     |
      | Test Firm East London    |
      | Test Firm Central London |

  Scenario: Filter by workplace pension advice
    When I am performing the "firm by name" search with value "Test Firm"
    And I check the options
      | name                                  |
      | Setting up a workplace pension scheme |
      | Financial advice for my employees     |
    Then I should see the following firms
      | name                     |
      | Test Firm Remote 2       |
      | Test Firm Central London |
