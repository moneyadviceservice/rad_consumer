Feature: Firm profile
  As a customer
  I want to see detailed information for each firm

  Scenario: View general firm information
    When I am viewing the profile for firm "Test Firm Central London"
    Then I can see the following general information
      | name                     | telephone     | email                 |
      | Test Firm Central London | 07111 333 271 | office271@example.net |

  Scenario: View firm details
    When I am viewing the profile for firm "Test Firm Central London"
    Then I can see the following details
      | name                 | value                |
      | Minimum fee          | £0                   |
      | Minimum pot size     | No minimum pot size  |
      | Free initial meeting | Free initial meeting |
    And I can see the following firm services
      | name                              |
      | Pension pot savings & investments |
      | Transferring a pension            |
      | Options when paying for care      |
      | Equity release                    |
      | Inheritance tax planning          |
      | Wills & probate                   |
    And I can see the following remote advice methods
      | name         |
      | At your home |

  Scenario: View firm offices
    When I am viewing the profile for firm "Test Firm Central London"
    And I click on the "offices" tab
    Then I can see the following offices
      | postcode | telephone     | email                 | website                        |
      | EC1N 2TD | 07111 333 271 | office271@example.net | http://example.net/offices/271 |
      | EC4V 4AY | 07111 333 885 | office885@example.com | http://example.net/offices/885 |

  Scenario: View firm advisers
    When I am viewing the profile for firm "Test Firm Central London"
    And I click on the "advisers" tab
    Then I can see the following advisers
      | name            |
      | Dr. Einar Stamm |
      | Gail D'Amore    |

  Scenario: Viewing a firm profile following search "in person" results
    When I am performing the "in person" search with value "EC4A 2AH"
    And I open the profile of firm "Test Firm Central London" from the results
    Then I can see the closest adviser "0.3" miles away
    When I click on the "offices" tab
    Then I can see the following offices ordered by distance
      | postcode |
      | EC1N 2TD |
      | EC4V 4AY |
    When I click on the "advisers" tab
    Then I can see the following advisers ordered by distance
      | postcode |
      | EC1N     |
      | EC4V     |

  Scenario: Viewing multiple firm profiles
    When I am viewing the profile for firm "Test Firm Central London"
    And I am viewing the profile for firm "Test Firm East London"
    Then I can see the list of the previously viewed firms
      | name                     |
      | Test Firm East London    |
      | Test Firm Central London |
