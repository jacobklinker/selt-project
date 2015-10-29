# Use this file to easily define all of your cron jobs.

every 4.hours do
    runner "GamesSyncJob.perform"
end
