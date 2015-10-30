Feature: Allow a user to login to the app

Scenario: Reach the login page
  When I am on the homepage
  And I click the "login" link
  Then I should see "Email"
  And I should see "Password"
  And I should see "Remember me"
  
Scenario: Create new user
  When I have added a user with email "test@test.com" and password "password"
  Then I should see "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."