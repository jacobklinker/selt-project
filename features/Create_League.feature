Feature: Authenticated users can create up to 5 leagues with up to 20 users in each league
  
  Scenario: I click the create league button
    Given the following users have been added:
    | email          | password | first_name | last_name | 
    | test@test.com  | password | name1      | name2     | 
    | test2@test.com | password | name3      | name4     | 
  
    When I login with "test@test.com" and password "password"
    When I am on the authenticated homepage
    When I click the "Create League" button
    Then I should see "Create League"
    And I should see "League name"
    And I should see "Conference settings"
    And I should see "Number picks settings"
    And I should see "Enter emails of members separated by commas"
    
  Scenario: I click the create league button
    Given the following users have been added:
    | email          | password | first_name | last_name | 
    | test@test.com  | password | name1      | name2     | 
    | test2@test.com | password | name3      | name4     | 
  
    When I login with "test@test.com" and password "password"
    When I am on the create new league page
    When I create a league with "Awesome League" as a League Name and "FBS" as conference settings and "5" as number of picks and email list containing "tyson@massey.com, tyler@parker.com"
    Then I should see "League Information"
    And I should see "Commissioner:"
    And I should see "Conference:"
    And I should see "Picks Per Week:"
    And I should see "League Standings"
    And I should see "Weekly Winners"