Given(/^I am on the score syncs admin page$/) do
    visit score_syncs_path
end

Given(/^the following score syncs have occured:$/) do |syncs|
    syncs.hashes.each do |sync|
        ScoreSync.create(:sync_start => sync[:sync_start], 
            :tweets_found => sync[:tweets_found], :tweets_used => sync[:tweets_used],
            :is_successful => sync[:is_successful])
    end
end

Then(/^I can see a list of all of the twitter syncs that have been performed$/) do
    expect(page).to have_content("2015-10-30 20:47:03 UTC")
    expect(page).to have_content("2015-10-30 21:47:03 UTC")
    expect(page).to have_content("2015-10-30 22:47:03 UTC")
end

When(/^I press the force sync button$/) do
    click_button 'force_sync'
end

When(/^I wait (\d+) seconds$/) do |seconds|
    sleep(seconds.to_i)
end