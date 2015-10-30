 Given /^I am on the homepage$/ do
  visit root_path
 end
 
 Given /^I am on the create user screen$/ do
  visit users_sign_up_path
 end
 
 When /^I click the "(.*?)" link$/ do |id|
  click_on id
 end
 
 When /^I click the "(.*?)" button$/ do |id|
  click_button id
 end
 
 Then /^I should see "(.*?)"$/ do |text|
  expect(page).to have_content(text)
 end
 
 When /^I have added a user with email "(.*?)" and password "(.*?)"$/ do |email, password|
  visit users_sign_up_path
  
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  
  click_button 'create'
 end
  
  