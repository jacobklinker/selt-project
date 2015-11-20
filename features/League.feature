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
    
    Scenario: Go to edit League page
      Given the following users have been added:
          | email          | password | first_name | last_name |
          | test@test.com  | password | test       | user      |
          | test2@test.com | password | test2      | user2     |
      
      Given the following leagues have been added:
          | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
          | Test League   | 1     | 2     | 1               | FBS                 | 5                     |       
            
      When I login with "test@test.com" and password "password"
      And I am on the league page
      And I click the "Edit League Settings" link
      Then I should see "Editing League"
    
  Scenario: I can edit a league as a commissioner 
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |       

    When I login with "test@test.com" and password "password"
    And I am on the league page
    And I click the "Edit" link
    Then the "League name" field should contain "Test League"
    And the "Number picks settings" field should contain "5"
    
  Scenario: I have the option to edit league settings as commissioner
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |       

    When I login with "test@test.com" and password "password"
    And I am on the league page
    And I should see "Edit League Settings"
  
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
    
  Scenario: I can be notified when another user hasn't made their picks yet for the week
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
    Then I should see "This user hasn't made any picks yet!"
    
  Scenario: I can see another user's picks for the week
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 |
    | Test League   | 1     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds |
    | Iowa        | Maryland  | 10        | -10       |
    | Iowa State  | Texas     | -8        | 8         |
    
    Given the following league picks have been added:
    | league_id     | user_id |
    | 1             | 1       |
    
    Given the following picks have been added:
    | game_id   | league_pick_id  | home_wins   |
    | 1         | 1               | true        |
    | 2         | 1               | false       |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "View" link
    Then I should see the picks listed on screen
    
  Scenario: I can clear a previously made pick
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
    And I choose the first away team
    Then I should see "test's Picks"