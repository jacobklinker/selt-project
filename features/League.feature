Feature: Authenticated users can view detailed information on the leagues they are in
  
  Scenario: I can see my leagues on the homescreen
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 |
    | Test League   | 1     | 2     |

    When I login with "test@test.com" and password "password"
    Then I should see "Test League"
    And I should see "Visit League"
  
  Scenario: I click the 'View League' button  
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 |
    | Test League   | 1     | 2     |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    Then I should see "Test League"
    And I should see "Commissioner: test@test.com"
    And I should see "test user"
    And I should see "test2 user2"
    
  Scenario: I can edit a league
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 |
    | Test League   | 1     | 2     |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    And I click the "Edit" link
    Then the "League name" field should contain "Test League"
    And the "Commissioner" field should contain "1"
    And the "Conference settings" field should contain "FBS"
    And the "Number picks settings" field should contain "5"
    And the "User1" field should contain "1"
    
  Scenario: I can make picks for the current week
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 |
    | Test League   | 1     | 2     |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see "test's Picks"
    
  Scenario: I can view a user's picks for the week
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 |
    | Test League   | 1     |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "View" link
    Then I should see "test's Picks"