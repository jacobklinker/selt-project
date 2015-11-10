Given /^I am on the unauthenticated homepage$/ do
  visit unauthenticated_root_path
 end
 
 When /^I am on the authenticated homepage$/ do
  visit authenticated_root_path
 end
 
 Given /the following users have been added:/ do |users_table|
  users_table.hashes.each do |user|
   user = User.new(:email => user[:email], :password => user[:password], :password_confirmation => user[:password], :first_name => user[:first_name], :last_name => user[:last_name])
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
 
 #When /^I signed up a user with email "(.*?)" and password "(.*?)"$/ do |email, password|
 # visit users_sign_up_path
 # 
 # fill_in "user_email", :with => email
 # fill_in "user_password", :with => password
 # fill_in "user_password_confirmation", :with => password
 # 
 # click_button 'create'
 #end
 
 When /^I signed up a user with email "(.*?)" and password "(.*?)" and first name "(.*?)" and last name "(.*?)"$/ do |email, password, first_name, last_name|
  visit users_sign_up_path
  
  fill_in "user_email", :with => email
  fill_in "user_first_name", :with => first_name
  fill_in "user_last_name", :with => last_name
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
