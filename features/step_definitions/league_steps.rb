Given /the following leagues have been added:/ do |leagues_table|
  leagues_table.hashes.each do |l|
   league = League.new
   league.commissioner_id = l[:user1]
   league.user1_id = l[:user1]
   league.user2_id = l[:user2]
   league.league_name = league[:name]
   
   league.save!
  end
 end
 
And /I am on the league page/ do 
  visit league_path(League.first())
end