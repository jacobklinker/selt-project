Feature: Authenticated users can create up to 5 leagues with up to 20 users in each league
  
  Scenario: I click the create league button
    Given the following users have been added:
    | email          | password | first_name | last_name | 
    | test@test.com  | password | name1      | name2     | 
    | test2@test.com | password | name3      | name4     | 
  
    When I login with "test@test.com" and password "password"
    When I am on the authenticated homepage
    When I click the "CREATE LEAGUE" button
    Then I should see "Create League"
    And I should see "League name"
    And I should see "Conference settings"
    And I should see "Number picks settings"
    And I should see "Enter emails of members separated by commas"
    
  Scenario: I create a new league
    Given the following users have been added:
    | email          | password | first_name | last_name | num_leagues |
    | test@test.com  | password | name1      | name2     | 1           |
    | test2@test.com | password | name3      | name4     | 1           |
  
    When I login with "test@test.com" and password "password"
    When I am on the create new league page
    When I create a league with "Awesome League" as a League Name and "FBS" as conference settings and "5" as number of picks and email list containing "tyson@massey.com, tyler@parker.com"
    Then I should see "League Information"
    And I should see "Commissioner:"
    And I should see "Conference:"
    And I should see "Picks Per Week:"
    And I should see "League Standings"
    And I should see "Weekly Winners"
    
  Scenario: I try to create a 6th league
    Given the following users have been added:
    | email          | password | first_name | last_name | league1_id | league2_id | league3_id | league4_id | league5_id | num_leagues |
    | test@test.com  | password | test       | user      |  1         |  2         |  3         |  4         |  5         | 5           |
    | test2@test.com | password | test1      | user2     |  1         |  2         |  3         |  4         |  5         | 5           |
    
     Given the following leagues have been added:
    | name          | user1 | user2| commissioner_id | conference_settings | number_picks_settings |
    | Test League1   | 1    | 2    | 1               | FBS                 | 5                 | 
    | Test League2   | 1    | 2    | 1               | FBS                 | 5                 | 
    | Test League3   | 1    | 2    | 1               | FBS                 | 5                 | 
    | Test League4   | 1    | 2    | 1               | FBS                 | 5                 | 
    | Test League5   | 1    | 2    | 1               | FBS                 | 5                 | 
    When I login with "test@test.com" and password "password"   
    When I am on the create new league page
    When I create a league with "Awesome League" as a League Name and "FBS" as conference settings and "5" as number of picks and email list containing "tyson@massey.com, tyler@parker.com"
    Then I should see "League not created because you have reached max number of leagues!!"
 