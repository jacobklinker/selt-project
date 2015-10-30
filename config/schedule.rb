# Use this file to easily define all of your cron jobs.

every 4.hours do
    runner "GamesSync.perform"
end

every 15.minutes do
    runner "ScoresSync.perform"
end
