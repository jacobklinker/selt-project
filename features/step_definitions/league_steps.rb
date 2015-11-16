Given /the following leagues have been added:/ do |leagues_table|
  leagues_table.hashes.each do |l|
   league = League.new
   league.commissioner_id = l[:user1]
   league.user1_id = l[:user1]
   league.user2_id = l[:user2]
   league.league_name = l[:name]
<<<<<<< HEAD
   league.conference_settings = "FBS"
   league.number_picks_settings = 5
=======
>>>>>>> origin/master
   
   league.save!
   
   u = User.find(1)
   u.league1_id = 1
   u.save!
  end
 end
 
And /I am on the league page/ do 
  visit league_path(League.first())
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end