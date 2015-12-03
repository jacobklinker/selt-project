Given /I visit the add announcement page/ do 
  visit leagues_add_announcements_path(1)
end

Given /the following announcements have been added, that are currently active:/ do |announcement_table|
  announcement_table.hashes.each do |a|
   announcement = Announcement.new
   announcement.league_id = a[:league_id]
   announcement.announcement = a[:announcement]
   announcement.start_date = DateTime.now.beginning_of_day - 1.day
   announcement.end_date = DateTime.now.end_of_day + 1.day
   
   announcement.save
  end
 end
 
 Given /the following announcements have been added, that are currently inactive:/ do |announcement_table|
  announcement_table.hashes.each do |a|
   announcement = Announcement.new
   announcement.league_id = a[:league_id]
   announcement.announcement = a[:announcement]
   announcement.start_date = DateTime.now.beginning_of_day + 1.day
   announcement.end_date = DateTime.now.end_of_day + 2.day
   
   announcement.save
  end
 end

When /^I type "(.*?)" into the "(.*?)" box$/ do |text, textbox|
  fill_in textbox, :with => text
end