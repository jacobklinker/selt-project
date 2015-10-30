require 'rails_helper'

describe Tweet do
    
    describe 'instantiation' do
        let!(:tweet) { build(:tweet) }
    
        it 'instantiates a tweet' do
            expect(tweet.class.name).to eq("Tweet")
        end
    end
    
end

describe GameTweet do
    
    describe "removing unneeded tweet information from example tweets" do
        
        it "should remove game time from parenthesis" do
            text = "Oregon 17 Arizona State 14 (12:28 IN 3RD) http://goo.gl/fb/ybrSr8 "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.include?("(12:28 IN 3RD)")).to be_falsy
        end
        
        it "should remove FINAL from parenthesis" do
            text = "Western Michigan 58 Eastern Michigan 28 (FINAL) http://goo.gl/fb/CsJq69 "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.include?("(FINAL)")).to be_falsy
        end
        
        it "should remove rankings" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.include?("(3)")).to be_falsy
        end
        
        it "should remove extra name information" do
            text = "Buffalo 29 Miami (OH) 24 (FINAL) http://goo.gl/fb/PTlv92 "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.include?("(OH)")).to be_falsy
        end
        
        it "should remove goo.gl links" do
            text = "Buffalo 29 Miami (OH) 24 (FINAL) http://goo.gl/fb/PTlv92 "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.include?("http://goo.gl/fb/PTlv92")).to be_falsy
        end
        
        it "should remove bit.ly links" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.include?("http://bit.ly/1MYh6Do")).to be_falsy
        end
        
        it "should not end with a space" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.end_with?(" ")).to be_falsy
        end
        
        it "should remove final colon from links when it exists" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text.end_with?(":")).to be_falsy
        end
        
        it "should process oregon vs arizona st in 2nd quarter" do
            text = "Oregon 10 Arizona State 0 (8:00 IN 2ND) http://goo.gl/fb/AV1y31 "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text).to eq("Oregon 10 Arizona State 0")
        end
        
        it "should process buffalo vs miami (oh) final" do
            text = "Buffalo 29 Miami (OH) 24 (FINAL) http://goo.gl/fb/PTlv92 "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text).to eq("Buffalo 29 Miami 24")
        end
        
        it "should process WV vs TCU final" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text).to eq("West Virginia 10 TCU 40")
        end
        
        it "should process western mi vs eastern mi in the 2nd" do
            text = "Western Michigan 51 Eastern Michigan 21 (9:17 IN 4TH) http://goo.gl/fb/zMeXXH "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text).to eq("Western Michigan 51 Eastern Michigan 21")
        end
        
        it "should process WV vs TCU at halftime" do
            text = "West Virginia 10 (3) TCU 23 (HALFTIME) http://goo.gl/fb/2P7K0O "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text).to eq("West Virginia 10 TCU 23")
        end
        
        it "should process game time tweets" do 
            text = "North Carolina at (24) Pittsburgh (THU, OCT 29 7:00 PM ET) http://goo.gl/fb/sTp9UB "
            text = GameTweet.remove_unneeded_tweet_info text
            expect(text).to eq("North Carolina at Pittsburgh")
        end
        
    end
    
    describe "split strings into words" do
        
        it "should work with single name teams" do
            text = "Buffalo 29 Miami 24"
            words = GameTweet.split_to_words text
            expect(words).to eq(['Buffalo', '29', 'Miami', '24'])
        end
        
        it "should work with multi-name teams" do
            text = "Western Michigan 51 Eastern Michigan 21"
            words = GameTweet.split_to_words text
            expect(words).to eq(['Western', 'Michigan', '51', 'Eastern', 'Michigan', '21'])
        end
        
        it "should work with split team names" do
            text = "West Virginia 10 TCU 23"
            words = GameTweet.split_to_words text
            expect(words).to eq(['West', 'Virginia', '10', 'TCU', '23'])
        end
        
        it "should work with random extra spaces" do
            text = "foo    bar something        else"
            words = GameTweet.split_to_words text
            expect(words).to eq(['foo', 'bar', 'something', 'else'])
        end
        
    end
    
    describe "getting game from original tweet" do
        
        it "should work for WV vs TCU" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            game = GameTweet.create(text)
            
            expect(game.home_team).to eq("TCU")
            expect(game.away_team).to eq("West Virginia")
            expect(game.home_score).to eq(40)
            expect(game.away_score).to eq(10)
        end
        
        it "should work for buffalo vs miami ohio" do
            text = "Buffalo 29 Miami (OH) 24 (FINAL) http://goo.gl/fb/PTlv92 "
            game = GameTweet.create(text)
            
            expect(game.home_team).to eq("Miami")
            expect(game.away_team).to eq("Buffalo")
            expect(game.home_score).to eq(24)
            expect(game.away_score).to eq(29)
        end
        
        it "should work for western mi vs eastern mi" do
            text = "Western Michigan 58 Eastern Michigan 28 (FINAL) http://goo.gl/fb/CsJq69 "
            game = GameTweet.create(text)
            
            expect(game.home_team).to eq("Eastern Michigan")
            expect(game.away_team).to eq("Western Michigan")
            expect(game.home_score).to eq(28)
            expect(game.away_score).to eq(58)
        end
        
        it "should work for north carolin vs pitt" do
            text = "(12) North Carolina 26 (24) Pittsburgh 19 (FINAL) http://goo.gl/fb/Z1y6pv "
            game = GameTweet.create(text)
            
            expect(game.home_team).to eq("Pittsburgh")
            expect(game.away_team).to eq("North Carolina")
            expect(game.home_score).to eq(19)
            expect(game.away_score).to eq(26)
        end
        
        it "should work for texas state vs georgia southern" do
            text = "Texas State 13 Georgia Southern 37 (FINAL) http://goo.gl/fb/TD4Jkt "
            game = GameTweet.create(text)
            
            expect(game.home_team).to eq("Georgia Southern")
            expect(game.away_team).to eq("Texas State")
            expect(game.home_score).to eq(37)
            expect(game.away_score).to eq(13)
        end
        
    end
    
end