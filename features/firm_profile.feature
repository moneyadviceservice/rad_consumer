Feature: Firm profile
  As a customer
  I want to see detailed information for each firm

  Background: Indexed firms and advisers
    Given I have a set of indexed firms and advisers

  Scenario: View general firm information
    Given I am on the profile of firm "First Test Firm"
    Then I can see the following general information
      | name            | telephone number | email address |
      | First Test Firm | 01214960497      | help@firsttestfirm.com |

  Scenario: View firm details
    Given I am on the profile of firm "First Test Firm"
    And I can see the following details
      | name                 | value               |
      | Minimum fee          | £0                  |
      | Minimum pot size     | No minimum pot size |
      | Free initial meeting |                     |
    Then I can see the following firm services
      | name                              |
      | Pension pot savings & investments |
      | Options when paying for care      |
      | Inheritance tax planning          |
    And I can see the following remote advice methods
      | name                  |
      | In person             |
      | By telephone          |
      | By video conferencing |

  Scenario: View firm offices
    Given I am on the profile of firm "First Test Firm"
    When I click on the "Offices" tab
    Then I can see the following offices
      | address  | telephone number | email address             | website                  |
      | EC1N 2TD | 01214960497      | office1@firsttestfirm.com | http://firsttestfirm.com |
      | E1 0AE   | 01214960498      | office2@firsttestfirm.com | http://firsttestfirm.com |

  Scenario: View firm advisers
    Given I am on the profile of firm "First Test Firm"
    When I click on the "Advisers" tab
    Then I can see the following advisers
      | name               |
      | Mr. Test Adviser 1 |
      | Mr. Test Adviser 2 |

  Scenario: Viewing a firm profile following search "in person" results
    When I search for in person advisers with postcode "EC1N 2TD"
    And I open the profile of one of the firms in the results
    Then I can see the distance between postcode "EC1N 2TD" and the closest adviser
    When I click on the "Offices" tab
    Then I can see offices ordered by distance from postcode "EC1N 2TD"
      | postcode |
      | EC1N 2TD |
      | E1 0AE   |
    When I click on the "Advisers" tab
    Then I can see adviser ordered by distance from postcode "EC1N 2TD"
      | postcode |
      | EC1N 2TD |
      | E1 0AE   |
      | BN2 1ET  |

  Scenario: Viewing multiple firm profiles
    When I visit the profile of the following firms
      | name             |
      | First Test Firm  |
      | Second Test Firm |
      | Third Test Firm  |
    And I visit the profile of firm "First Test Firm" again
    Then I can see the list of the previously viewed firm without "First Test Firm"
      | name             |
      | Second Test Firm |
      | Third Test Firm  |
