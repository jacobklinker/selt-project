Feature: Administrators can view all games in the database
  
  Scenario: I can see all games listed on the index
    Given the following games have synced:
      | home_team   | away_team | home_odds | away_odds | game_time        |
      | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
      | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given I am on the games admin page
    Then I can see a list of games that are saved
    
  Scenario: I can edit a game and add a score to it
    Given the following games have synced: 
      | home_team   | away_team | home_odds | away_odds | game_time        |
      | Iowa        | Maryland  | 10        | -10       | TODAYS_DATE      |
      | Iowa State  | Texas     | -8        | 8         | TODAYS_DATE      |
    
    Given I am on the games admin page
    Then I can press the edit button
    And I can edit the home and away scores
    Then I can press the save button
    And I can see the updated scores in the table