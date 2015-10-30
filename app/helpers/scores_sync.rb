# We can use Pinnacle Sport's XML API for grabbing games from the week and odds
# to go with those games, but there isn't a way to get score from this.
#
# Instead, to get final game scores so that we can assess players and choose a
# winner, we will get these scores from the Twitter account @ncaaupdates. This
# Twitter user constantly tweets out game updates for score updates and final 
# scores, so we will look for the final scores and include them in the Game
# ActiveRecord object.
#
# Currently, this job will only find final scores, it will not parse tweets that
# contain score updates in the middle of the game. This is functionality that
# should be provided in the future however, since it will be important for
# players before the service goes live. Players should be able to use this
# application as a one stop shop for all game updates ideally.
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
    
    # Process the tweet and update the sync object.
    def self.process_tweet(tweet, sync)
        
        if tweet != nil && tweet != ""
            # remove the links and anything inside parenthesis
            if tweet.include?("FINAL")
                game_tweet = GameTweet.create(tweet)
                sync.tweets_used = sync.tweets_used + 1
            end
        end
        
        sync.tweets_found = sync.tweets_found + 1
    end
    
    # set up our client with the correct consumer key and secret
    def self.set_client
        @client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "kbcI3QLPYOwSy7pJzNcSauOJt"
            config.consumer_secret     = "tbWLqhi3dQZyP0u1jmgRUFUJxcvPchUYuA0KazwqOfcgSSOHVG"
            # config.access_token        = "YOUR_ACCESS_TOKEN"
            # config.access_token_secret = "YOUR_ACCESS_SECRET"
        end
    end
    
end