Given(/^I am on the games admin page$/) do
    visit games_path
end

Given(/^the following games have synced:$/) do |games|
    games.hashes.each do |game|
        Game.create(:home_team => game[:home_team], :away_team => game[:away_team],
            :home_odds => game[:home_odds], :away_odds => game[:away_odds], :game_time => game[:game_time])
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