Given /the following leagues have been added:/ do |leagues_table|
  leagues_table.hashes.each do |l|
   league = League.new
   league.commissioner_id = l[:user1]
   league.user1_id = l[:user1]
   league.league_name = l[:name]
   league.conference_settings = "FBS"
   league.number_picks_settings = 5

   league.save!
   
   u = User.find(1)
   u.league1_id = 1
   u.save!
  end
 end
 
And /I am on the league page/ do 
  visit league_path(League.first())
end

And /I choose the first away team/ do
    find('.left', 'picks[1]').click()
end

And /I clear my pick/ do
    
end

Then /I should have one pick/ do
end

Then /I should have zero picks/ do
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end