 Given /^I am on the homepage$/ do
  visit root_path
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
  