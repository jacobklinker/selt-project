Feature: Administrators can view all games in the database
  
  Scenario: I can see all games listed on the index
    Given the following games have synced:
      | home_team   | away_team | home_odds | away_odds |
      | Iowa        | Maryland  | 10        | -10       |
      | Iowa State  | Texas     | -8        | 8         |
    
    Given I am on the games admin page
    Then I can see a list of games that are saved