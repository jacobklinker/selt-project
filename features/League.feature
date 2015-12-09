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

    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time           |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE         |
    | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE         |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |
    
    Given the following league picks have been added:
    | league_id     | user_id |
    | 1             | 1       |
    | 1             | 2       |
    
    Given the following picks have been added:
    | game_id   | league_pick_id  | home_wins   |
    | 1         | 1               | true        |
    | 2         | 1               | false       |
    | 1         | 2               | true        |
    | 2         | 2               | true        |

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
    When it is between "Wednesday" and "Friday"
    When I click the "Make picks for this week" button
    Then I should see "test's Picks"
    
  Scenario: I am redirected to make my picks when I try and view them
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When it is between "Wednesday" and "Friday"
    When I click the first user
    Then I should see my picks listed on the screen
    
  Scenario: I can be notified I need to make my picks before viewing other's picks
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 1    | TODAYS_DATE |
    
    Given the following league picks have been added:
    | league_id     | user_id |
    | 1             | 2       |
    
    Given the following tiebreaker picks have been added:
    | league_pick_id | points_estimate |
    | 1              | 69              |
    
    Given the following picks have been added:
    | game_id   | league_pick_id  | home_wins   |
    | 1         | 1               | true        |
    | 2         | 1               | false       |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When it is between "Wednesday" and "Friday"
    When I click the second user
    Then I should see "You need to make your picks before you can view other's!"
    
  Scenario: I can be notified when another user hasn't made their picks yet for the week
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |

    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 1    | TODAYS_DATE |
    
    Given the following league picks have been added:
    | league_id     | user_id |
    | 1             | 1       |
    
    Given the following tiebreaker picks have been added:
    | league_pick_id | points_estimate |
    | 1              | 69              |
    
    Given the following picks have been added:
    | game_id   | league_pick_id  | home_wins   |
    | 1         | 1               | true        |
    | 2         | 1               | false       |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When it is between "Wednesday" and "Friday"
    When I click the second user
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
    | Iowa        | Maryland  | 10        | -10       | WEEK_AGO            |
    | Iowa State  | Texas     | -8        | 8         | WEEK_AGO            |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE         |
    | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE         |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | WEEK_AGO    |
    | 1      | 3    | TODAYS_DATE |
    
    Given the following league picks have been added:
    | league_id     | user_id |
    | 1             | 1       |
    | 1             | 2       |
    | 1             | 1       |
    | 1             | 2       |
    
    Given the following picks have been added:
    | game_id   | league_pick_id  | home_wins   |
    | 1         | 1               | true        |
    | 2         | 1               | false       |
    | 1         | 2               | true        |
    | 2         | 2               | true        |
    | 3         | 1               | true        |
    | 4         | 1               | false       |
    | 3         | 2               | true        |
    | 4         | 2               | true        |
    
    Given the following tiebreaker picks have been added:
    | league_pick_id | points_estimate |
    | 1              | 69              |
    | 2              | 123             |
    | 3              | 69              |
    | 4              | 123             |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    # TODO fixme, should be second user not first user
    When it is between "Wednesday" and "Friday"
    When I click the second user
    Then I should see the picks for the second user listed on screen
    
  Scenario: I can see my picks for the week
    Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |

    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | FBS                 | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time           |
    | Iowa        | Maryland  | 10        | -10       | WEEK_AGO            |
    | Iowa State  | Texas     | -8        | 8         | WEEK_AGO            |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE         |
    | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE         |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | WEEK_AGO    |
    | 1      | 3    | TODAYS_DATE |
    
    Given the following league picks have been added:
    | league_id     | user_id |
    | 1             | 1       |
    | 1             | 2       |
    | 1             | 1       |
    | 1             | 2       |
    
    Given the following picks have been added:
    | game_id   | league_pick_id  | home_wins   |
    | 1         | 1               | true        |
    | 2         | 1               | false       |
    | 1         | 2               | true        |
    | 2         | 2               | true        |
    | 3         | 1               | true        |
    | 4         | 1               | false       |
    | 3         | 2               | true        |
    | 4         | 2               | true        |
    
    Given the following tiebreaker picks have been added:
    | league_pick_id | points_estimate |
    | 1              | 69              |
    | 2              | 123             |
    | 3              | 69              |
    | 4              | 123             |

    When I login with "test@test.com" and password "password"
    And I am on the league page
    When it is between "Wednesday" and "Friday"
    When I click the first user
    Then I should see the picks for the first user listed on screen
    
  Scenario: I can pick only Big 10 games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Big 10                 | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 1    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should see "Iowa"
    And I should not see "Texas"
    
    
  Scenario: I can pick only SEC games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | SEC                    | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Alabama     | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Alabama"
    
  Scenario: I can pick only ACC games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | ACC                    | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Duke        | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Duke"
    
  Scenario: I can pick only PAC 12 games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
    | Test League   | 1     | 2     | 1               | PAC 12                 | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Oregon      | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Oregon"
  
  Scenario: I can pick only Mid-American Conference games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings     | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Mid-American Conference | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Ohio        | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Ohio"
  
  Scenario: I can pick only Mountain West Conference games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings      | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Mountain West Conference | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Wyoming     | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Wyoming"
    
   Scenario: I can pick only Sun Belt games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Sun Belt            | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Idaho       | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Idaho"
    
  Scenario: I can pick only Big 12 games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Big 12              | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Kansas      | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Kansas"
    
  Scenario: I can pick only Conference USA games:
     Given the following users have been added:
    | email          | password | first_name | last_name |
    | test@test.com  | password | test       | user      |
    | test2@test.com | password | test2      | user2     |
    
    Given the following leagues have been added:
    | name          | user1 | user2 | commissioner_id | conference_settings         | number_picks_settings |
    | Test League   | 1     | 2     | 1               | Conference USA              | 5                     |
    
    Given the following games have synced:
    | home_team   | away_team | home_odds | away_odds | game_time        |
    | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
    | Marshall    | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given the following tiebreakers have been added:
    | league | game | week        |
    | 1      | 2    | TODAYS_DATE |

    When I login with "test@test.com" and password "password"
    And I am on the picks page
    Then I should not see "Iowa"
    And I should see "Marshall"
    
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
    When it is between "Wednesday" and "Friday"
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
    When it is between "Wednesday" and "Friday"
    When I click the "Make picks for this week" button
    And I make 11 picks
    Then the "Submit Picks" button should be enabled