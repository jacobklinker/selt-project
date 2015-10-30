Given(/^I am on the syncs admin page$/) do
    visit syncs_path
end

Given(/^the following syncs have occured:$/) do |syncs|
    syncs.hashes.each do |sync|
        Sync.create(:timestamp => sync[:timestamp], :new_games => sync[:new_games],
            :updated_games => sync[:updated_games], :failed_games => sync[:failed_games],
            :is_successful => sync[:is_successful])
    end
end

Then(/^I can see a list of all of the syncs that have been performed$/) do
    expect(page).to have_content("2015-10-30 20:47:03 UTC")
    expect(page).to have_content("2015-10-30 21:47:03 UTC")
    expect(page).to have_content("2015-10-30 22:47:03 UTC")
end