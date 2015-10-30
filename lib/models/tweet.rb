# Placeholder class for testing with Factory Girl.
class Tweet
    attr_accessor :text
end

# Class to help out with grabbing and parsing game information from tweets by
# @ncaaupdates
class GameTweet
    
    attr_accessor :home_team
    attr_accessor :away_team
    attr_accessor :home_score
    attr_accessor :away_score
    
    # parse the tweet into a home team, away team, and their respective scores
    def self.create(tweet)
        tweet = remove_unneeded_tweet_info tweet
        words = split_to_words tweet
        
        game = GameTweet.new
        game.home_team = ''
        game.away_team = ''
        game.home_score = 0
        game.away_score = 0
        
        words.each do |word|
            begin
                # if it isn't an int, then we should keep adding onto team name
                # otherwise go ahead and count it as the score
                score = Integer(word)
                if game.away_score == 0
                    game.away_score = score
                else
                    game.home_score = score
                end
            rescue
                if game.away_score == 0
                    game.away_team = game.away_team + ' ' + word
                else
                    game.home_team = game.home_team + ' ' + word
                end
            end
        end
        
        game.home_team = game.home_team.strip
        game.away_team = game.away_team.strip
        
        return game
    end
    
    # remove anything inside parenthesis
    def self.remove_unneeded_tweet_info(tweet)
        return tweet.gsub(/ *\(.*?\):?|http.*/, '').gsub(/ *?$/, '')
    end
    
    # split the string by blank spaces
    def self.split_to_words(str)
        return str.gsub(/\s+/m, ' ').strip.split(" ")
    end
    
end