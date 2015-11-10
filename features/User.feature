Feature: Authenticated users can use the top navigation bar
  
Scenario: Log out from authenticated account
  Given the following users have been added:
  | email          | password |
  | test@test.com  | password |
  
  When I login with "test@test.com" and password "password"
  And I click the "Logout" link
  Then I should see "Signed out successfully"
  And I should see "Login"
  
Scenario: Return to user homepage when authenticated
  Given the following users have been added:
  | email          | password |
  | test@test.com  | password |

  When I login with "test@test.com" and password "password"
  And I click the "Home" link
  Then I should see "Welcome to"
  And I should see "Logout"
  And I should see "Announcements"
  And I should see "My Leagues"
  #And I should see "Create League"
  And I should see "Account Settings"
  And I should not see "Login"

  
Scenario: Go to account settings page
  Given the following users have been added:
  | email          | password |
  | test@test.com  | password |
  
  When I login with "test@test.com" and password "password"
  And I click the "Account Settings" link
  Then I should see "Adjust your account settings here."