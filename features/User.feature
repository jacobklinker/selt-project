Feature: Authenticated users can use the top navigation bar
  
Scenario: Log out from authenticated account
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  When I login with "test@test.com" and password "password"
  And I click the "Logout" link
  Then I should see "Signed out successfully"
  And I should see "Login"
  
Scenario: Return to user homepage when authenticated
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |

  When I login with "test@test.com" and password "password"
  And I click the "Home" link
  Then I should see "Welcome to"
  And I should see "Logout"
  And I should see "My Leagues"
  #And I should see "Create League"
  And I should see "About Pick 'Em"
  And I should not see "Login"

  
Scenario: Go to About Pick 'Em page
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  When I login with "test@test.com" and password "password"
  And I click the "About Pick 'Em" link
  Then I should see "Adjust your account settings here."