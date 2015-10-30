# Placeholder class for testing with Factory Girl.
class Tweet
    attr_accessor :text
end

class GameTweet
    
    attr_accessor :home_team
    attr_accessor :away_team
    attr_accessor :home_score
    attr_accessor :away_score
    
    def self.create(tweet)
        tweet = remove_unneeded_tweet_info tweet
    end
    
    def self.remove_unneeded_tweet_info(tweet)
        return tweet.gsub(/ *\(.*?\):?|http.*/, '').gsub(/ *?$/, '')
    end
    
end