Feature: Authenticated users can view detailed information on the leagues they are in
  
  Scenario: I can see my leagues on the homescreen
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 | conference_setting | picks_setting |
    | Test League   | 1     | 2     | FBS                | 5             |

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
    And the "Conference settings" field should contain "FBS"
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
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |

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
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |

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
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time           |
    | Iowa        | Maryland  | 10        | -10       | 2015-11-14T16:05:00 |
    | Iowa State  | Texas     | -8        | 8         | 2015-11-14T16:05:00 |
    
    Given the following league picks have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |
    
    Given the following picks have been added:
    | game_id   | league_pick_id  | home_wins   |
    | 1         | 1               | true        |
    | 2         | 1               | false       |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "View" link
    Then I should see the picks listed on screen
    
  Scenario: I can pick only Big 10 games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Big 10                 | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "Big 10" games
    
  Scenario: I can pick only SEC games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | SEC                    | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "SEC" games
    
  Scenario: I can pick only ACC games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | ACC                    | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "ACC" games
    
  Scenario: I can pick only PAC 12 games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | PAC 12                 | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "PAC 12" games
  
  Scenario: I can pick only Mid-American Conference games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings     | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Mid-American Conference | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "Mid-American Conference" games
  
  Scenario: I can pick only Mountain West Conference games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings      | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Mountain West Conference | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "Mountain West Conference" games
    
   Scenario: I can pick only Sun Belt games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Sun Belt            | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "Sun Belt" games
    
  Scenario: I can pick only Big 12 games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Big 12              | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "Big 12" games
    
  Scenario: I can pick only Conference USA games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings         | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Conference USA              | 5                     |
    
    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    Then I should see only "Conference USA" games
    
  Scenario: I cannot submit picks before I pick the required number of games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                    | 2                     |

    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    And I make 1 picks
    Then the "Submit Picks" button should be disabled
    
  Scenario: I can submit picks once I pick the required number of games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                    | 2                     |

    Given I am on the syncs admin page
    When I press the force sync button
    
    When I login with "test@test.com" and password "password"
    And I am on the league page
    When I click the "Make picks for this week" button
    And I make 11 picks
    Then the "Submit Picks" button should be enabled