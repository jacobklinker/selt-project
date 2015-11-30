Given /I visit the add announcement page/ do 
  visit leagues_add_announcements_path(1)
end

When /^I type "(.*?)" into the "(.*?)" box$/ do |text, textbox|
  fill_in textbox, :with => text
end