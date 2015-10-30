class ScoresSync
    
    def self.perform
        sync = ScoreSync.new
        sync.sync_start = Time.now
        
        set_client
        
        # find all tweets for the @ncaaupdates user since the last time we 
        # synced and process each of them.
        @client.user_timeline("ncaaupdates").each do |tweet|
           process_tweet tweet.text, sync
        end
        
        sync.save
        
    end
    
    def self.process_tweet(tweet, sync)
        sync.tweets_used = sync.tweets_used + 1
        sync.tweets_found = sync.tweets_found + 1
    end
    
    def self.set_client
        @client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "kbcI3QLPYOwSy7pJzNcSauOJt"
            config.consumer_secret     = "tbWLqhi3dQZyP0u1jmgRUFUJxcvPchUYuA0KazwqOfcgSSOHVG"
            # config.access_token        = "YOUR_ACCESS_TOKEN"
            # config.access_token_secret = "YOUR_ACCESS_SECRET"
        end
    end
    
end