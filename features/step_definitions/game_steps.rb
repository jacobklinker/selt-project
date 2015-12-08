Given(/^I am on the games admin page$/) do
    visit games_path
end

Given(/^the following games have synced:$/) do |games|
    
    games.map_column!('game_time') do |game_time| 
        if game_time == 'TODAYS_DATE'
          game_time = Time.now.in_time_zone("Central Time (US & Canada)")
        elsif game_time == 'WEEK_AGO'
          game_time = 1.week.ago.in_time_zone("Central Time (US & Canada)")
        end
    end
    games.hashes.each do |game|
        g=Game.create(:home_team => game[:home_team], :away_team => game[:away_team],
            :home_odds => game[:home_odds], :away_odds => game[:away_odds], :game_time => game[:game_time])
    end
end

Given(/^the following tiebreakers have been added:$/) do |tiebreakers|
    #week = Time.now.strftime('%U').to_i
    #day = Time.now.strftime('%w').to_i
    tiebreakers.map_column!('week') do |week| 
        if week == 'TODAYS_DATE'
          week = Time.now.in_time_zone("Central Time (US & Canada)").strftime("%U")
        elsif week == 'WEEK_AGO'
          week = 1.week.ago.in_time_zone("Central Time (US & Canada)").strftime("%U")
        end
    end
    tiebreakers.hashes.each do |tiebreaker|
        t = Tiebreaker.create(:league_id => tiebreaker[:league], :week => tiebreaker[:week], :game_id => tiebreaker[:game])
    end
end

Given(/^the following tiebreaker picks have been added:$/) do |tiebreaker_picks|
    #week = Time.now.strftime('%U').to_i
    #day = Time.now.strftime('%w').to_i
  
    tiebreaker_picks.hashes.each do |tiebreaker_pick|
        t = TiebreakerPick.create(:league_pick_id => tiebreaker_pick[:league_pick_id], :points_estimate => tiebreaker_pick[:points_estimate])
    end
end

Then(/^I can see a list of games that are saved$/) do
    expect(page).to have_content("Iowa / 10")
    expect(page).to have_content("Maryland / -10")
    expect(page).to have_content("Iowa State / -8")
    expect(page).to have_content("Texas / 8")
end

Then(/^I can press the edit button$/) do
    click_on "edit", :match => :first
end

Then(/^I can edit the home and away scores$/) do
    fill_in "Away Score", :with => "12"
    fill_in "Home Score", :with => "5"
    select true, :from => "Is Finished?"
end

Then(/^I can press the save button$/) do
    click_on "save"
end

Then(/^I can see the updated scores in the table$/) do
    expect(page).to have_content("Iowa / 10")
    expect(page).to have_content("Maryland / -10")
    expect(page).to have_content("Iowa State / -8")
    expect(page).to have_content("Texas / 8")
    expect(page).to have_content("12")
    expect(page).to have_content("5")
    expect(page).to have_content("true")
end