Feature: Users can create an account and login

Scenario: Reach the login page
  When I am on the unauthenticated homepage
  And I click the "login" link
  Then I should see "Email"
  And I should see "Password"
  And I should see "Remember me"
  
Scenario: Create new user
  When I signed up a user with email "test@test.com" and password "password" and first name "test" and last name "user"
  Then I should see "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
  
Scenario: Login to unconfirmed account
  When I signed up a user with email "test@test.com" and password "password" and first name "test" and last name "user"
  And I login with "test@test.com" and password "password"
  Then I should see "You have to confirm your email address before continuing."
  
Scenario: Login to confirmed account
  Given the following users have been added:
  | email          | password | first_name | last_name |
  | test@test.com  | password | test       | user      |
  
  When I login with "test@test.com" and password "password"
  Then I should see "Signed in successfully."
  And I should see "Welcome to Pick 'Em, test!"
  And I should see "Logout"
  And I should see "My Leagues"
  And I should see "Account Settings"
  And I should not see "Login"
