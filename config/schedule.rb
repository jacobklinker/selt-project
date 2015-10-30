# Every 4 hours, we should check for updates from Pinnacle Sports
every 4.hours do
    runner "GamesSync.perform"
end

# Every 15 minutes, we should check for updates to scores from Twitter
every 15.minutes do
    runner "ScoresSync.perform"
end
