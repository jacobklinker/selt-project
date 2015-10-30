Feature: Users can create an account and login

Scenario: Reach the login page
  When I am on the homepage
  And I click the "login" link
  Then I should see "Email"
  And I should see "Password"
  And I should see "Remember me"
  
Scenario: Create new user
  When I signed up a user with email "test@test.com" and password "password"
  Then I should see "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
  
Scenario: Login to unconfirmed account
  When I signed up a user with email "test@test.com" and password "password"
  And I login with "test@test.com" and password "password"
  Then I should see "You have to confirm your email address before continuing."
  
Scenario: Login to confirmed account
  Given the following users have been added:
  | email          | password |
  | test@test.com  | password |
  
  When I login with "test@test.com" and password "password"
  Then I should see "Signed in successfully."