When /^I create a league with "(.*?)" as a League Name and "(.*?)" as conference settings and "(.*?)" as number of picks and email list containing "(.*?)"$/ do |league_name,conf_settings,num_picks,emails|
  
  fill_in "league_league_name", :with => league_name
  fill_in "email_list", :with => emails
  select conf_settings, :from => "league_conference_settings"
  select num_picks, :from => "league_number_picks_settings"
  
  click_on 'Create League'
  puts page.body
end
 
When /^I am on the create new league page$/ do
  visit new_league_path
end