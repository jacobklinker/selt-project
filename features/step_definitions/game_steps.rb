Given(/^I am on the games admin page$/) do
    visit games_path
end

Given(/^the following games have synced:$/) do |games|
    games.hashes.each do |game|
        Game.create(:home_team => game[:home_team], :away_team => game[:away_team],
            :home_odds => game[:home_odds], :away_odds => game[:away_odds])
    end
end

Then(/^I can see a list of games that are saved$/) do
    expect(page).to have_content("Iowa / 10")
    expect(page).to have_content("Maryland / -10")
    expect(page).to have_content("Iowa State / -8")
    expect(page).to have_content("Texas / 8")
end