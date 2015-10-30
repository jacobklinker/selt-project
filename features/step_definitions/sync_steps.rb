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