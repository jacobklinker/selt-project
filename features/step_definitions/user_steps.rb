 Given /^I am on the homepage$/ do
  visit authenticated_root_path
 end
 
 Given /the following users have been added:/ do |users_table|
  users_table.hashes.each do |user|
   user = User.new(:email => user[:email], :password => user[:password], :password_confirmation => user[:password])
   user.skip_confirmation!
   user.save!
  end
end
 
 When /^I click the "(.*?)" link$/ do |id|
  click_on id
 end
 
 When /^I click the "(.*?)" button$/ do |id|
  click_button id
 end
 
 When /^I signed up a user with email "(.*?)" and password "(.*?)"$/ do |email, password|
  visit users_sign_up_path
  
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  
  click_button 'create'
 end
 
 When /^I login with "(.*?)" and password "(.*?)"$/ do |email, password|
  visit users_sign_in_path
  
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  
  click_button 'log_in'
 end
 
 Then /^I should see "(.*?)"$/ do |text|
  expect(page).to have_content(text)
 end
 
 Then /^I should not see "(.*?)"$/ do |text|
  expect(page).to have_no_content(text)
 end
  