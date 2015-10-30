Feature: Allow a user to login to the app

Scenario: Reach the login page
  When I am on the homepage
  And I click the "login" link
  Then I should see "Email"
  And I should see "Password"
  And I should see "Remember me"