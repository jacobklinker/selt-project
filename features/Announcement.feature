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
  And I click the "create" button
  Then I should see "Added an announcement to your league!"