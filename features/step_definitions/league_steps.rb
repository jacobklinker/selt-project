Given /the following leagues have been added:/ do |leagues_table|
  leagues_table.hashes.each do |l|
   league = League.new
   league.commissioner_id = l[:user1]
   league.user1_id = l[:user1]
   league.user2_id = l[:user2]
   league.league_name = l[:name]
   league.conference_settings = l[:conference_settings]
   league.number_picks_settings = l[:number_picks_settings]

   league.save!
   
   u = User.find(1)
   u.league1_id = 1
   u.save!
  end
 end
 
And /I am on the league page/ do 
  visit league_path(League.first())
end

And /I am on the picks page/ do
    visit games_picks_path(League.first(), Tiebreaker.first())
end

And /I choose the first away team/ do
    find('.left', 'picks[1]').click()
end

And /I make (\d+) picks/ do |n|

    num_picks = n.to_i
    
    radios = page.all(:xpath, "//input[@class='left']")
    i = 0
    while i < num_picks
        id = radios[i+1][:id]
        choose(id)
        i+=1
    end
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end

Given(/^the following league picks have been added:$/) do |table|
    week = Time.now.strftime('%U')
    
    if (Time.now.wday <= 2) 
        week = week.to_i - 1
    end
    
    table.hashes.each do |league_pick|
        LeaguePick.create(:league_id => league_pick[:league_id], 
            :user_id => league_pick[:user_id], :week => week)
    end
end

Given(/^the following picks have been added:$/) do |table|
    table.hashes.each do |pick|
        Pick.create(:league_pick_id => pick[:league_pick_id], 
            :game_id => pick[:game_id], :home_wins => pick[:home_wins])
    end
end

When(/^I click the first user$/) do
    find(:xpath, "//a[@href='/games/show_picks/1/1']").click
end

When(/^I click the make or view picks button$/) do
    day = Time.now.strftime("%w").to_i
    if day < 3
        click_button("View everyone's picks for last week")
        print "VIEW PICKS LAST WEEK"
    else
        click_button("Make picks for this week")
        print "MAKE PICKS"
    end
end

When(/^I click the make picks button$/) do
    find(:xpath, "//input[@value='Make picks for this week']").click
end

When(/^I click the second user$/) do
    find(:xpath, "//a[@href='/games/show_picks/1/2']").click
end

When /^it is between "([^\"]*)" and "([^\"]*)"$/ do |first_day, last_day|
    case first_day
        when "Sunday"
            first_day=0
        when "Monday"
            first_day=1
        when "Tuesday"
            first_day=2
        when "Wednesday"
            first_day=3
        when "Thursday"
            first_day=4
        when "Friday"
            first_day=5
        when "Saturday"
            first_day=6
        else
            pending "INVALID DAY PROVIDED"
    end
        
    case last_day
        when "Sunday"
            last_day=0
        when "Monday"
            last_day=1
        when "Tuesday"
            last_day=2
        when "Wednesday"
            last_day=3
        when "Thursday"
            last_day=4
        when "Friday"
            last_day=5
        when "Saturday"
            last_day=6
        else
            pending "INVALID DAY PROVIDED"
    end
    
    day = Time.now.in_time_zone("Central Time (US & Canada)").strftime("%w").to_i
    
    if day < first_day || day > last_day
        pending "FEATURE NOT AVAILABLE ON THIS DAY OF THE WEEK"
    end
end

Then(/^I should see the picks for the first user listed on screen$/) do
    expect(page).to have_content("Iowa")
    expect(page).to have_content("Iowa State")
    expect(page).to have_content("test's Picks")
end

Then(/^I should see my picks listed on the screen$/) do
    expect(page).to have_content("test's Picks")
end

Then(/^I should see the picks for the second user listed on screen$/) do
    expect(page).to have_content("Iowa")
    expect(page).to have_content("Iowa State")
    expect(page).to have_content("test2's Picks")
end

Then (/I should see only "([^\"]*)" games/) do |conference|
    case conference
        when "Big 10"
            max_games = 14
        when "SEC"
            max_games = 14
        when "ACC"
            max_games = 14
        when "PAC 12"
            max_games = 12
        when "Mid-American Conference"
            max_games = 13
        when "American Athletic Conference"
            max_games = 12
        when "Big 12"
            max_games = 10
        when "Mountain West Conference"
            max_games = 12
        when "Conference USA"
            max_games = 13
        when "Sun Belt"
            max_games = 11
    end
    rows = page.all("table#games tr").count - 1
    
    expect(rows).to be <= max_games  
end

Then /the "([^\"]*)" button should be disabled/ do |button_name|
    expect(page).to have_selector("input[type=submit][value='Submit Picks'][disabled='disabled']")
end

Then /the "([^\"]*)" button should be enabled/ do |button_name|
    expect(page).to have_selector("input[type=submit][value='Submit Picks']")
end