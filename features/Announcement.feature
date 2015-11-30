Feature: Announcements can be added to a league and displayed to that leagues users
  
Scenario: Admins for a league can add an announcement to existing leagues
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