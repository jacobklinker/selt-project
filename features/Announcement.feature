Feature: Announcements can be added to a league and displayed to that leagues users
  
Scenario: View a page to add announcements to existing leagues
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  Given the following leagues have been added:
  | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
  | Test League   | 1     | 2     | 1               | FBS                    | 2                     |


  When I login with "test@test.com" and password "password"
  And I visit the add announcement page
  Then I should see "Add Announcement to"
  And I should see "Test League"

Scenario: The league doesn't existing
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |

  When I login with "test@test.com" and password "password"
  And I visit the add announcement page
  Then I should see "Oops, that league doesn't exist!"
  
Scenario: Add announcement to an existing league
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  Given the following leagues have been added:
  | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
  | Test League   | 1     | 2     | 1               | FBS                    | 2                     |


  When I login with "test@test.com" and password "password"
  And I visit the add announcement page
  And I type "Test Announcement" into the "announcement" box
  And I type "12-05-2015" into the "start_time" box
  And I type "12-07-2015" into the "end_time" box
  And I click the "create" button
  Then I should see "Added an announcement to your league!"
  
Scenario: Commissioners for a league can see a button to add announcement when viewing a league
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  | test2@test.com | password | test       | user 2    |
  
  Given the following leagues have been added:
  | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
  | Test League   | 1     | 2     | 1               | FBS                    | 2                     |
  
  When I login with "test@test.com" and password "password"    
  And I am on the league page
  Then I should see "As an admin, you can create announcements that your leagues' other players can view"

  
Scenario: Normal users on a league cannot see the announcements button.
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  | test2@test.com | password | test       | user 2    |
  
  Given the following leagues have been added:
  | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
  | Test League   | 1     | 2     | 1               | FBS                    | 2                     |
  
  When I login with "test2@test.com" and password "password"
  And I am on the league page
  Then I should not see "As an admin, you can create announcements that your leagues' other players can view"
  
Scenario: Users can view announcements on their homescreen
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  Given the following leagues have been added:
  | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
  | Test League   | 1     | 2     | 1               | FBS                    | 2                     |
  
  Given the following announcements have been added, that are currently active:
  | announcement          | league_id |
  | testing announcements | 1         |
  | testing 2             | 1         |


  When I login with "test@test.com" and password "password"
  Then I should see "testing announcements"
  And I should see "testing 2"
  
Scenario: Users can view announcements on their homescreen, that are only for the leagues they are involved in
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  Given the following leagues have been added:
  | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
  | Test League   | 1     | 2     | 1               | FBS                    | 2                     |
  
  Given the following announcements have been added, that are currently active:
  | announcement          | league_id |
  | testing announcements | 2         |
  | testing 2             | 2         |


  When I login with "test@test.com" and password "password"
  Then I should not see "testing announcements"
  And I should not see "testing 2"
  
Scenario: Users can view announcements on their homescreen, that are only for the leagues they are involved in
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  Given the following leagues have been added:
  | name          | user1 | user2 | commissioner_id | conference_settings    | number_picks_settings |
  | Test League   | 1     | 2     | 1               | FBS                    | 2                     |
  
  Given the following announcements have been added, that are currently active:
  | announcement          | league_id |
  | testing announcements | 1         |
  | testing 2             | 2         |


  When I login with "test@test.com" and password "password"
  Then I should see "testing announcements"
  And I should not see "testing 2"