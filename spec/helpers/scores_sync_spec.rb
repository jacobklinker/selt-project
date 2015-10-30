require 'rails_helper'

describe "scores background sync" do
    
    it "should save a score sync object" do
        @sync = ScoreSync.new
        @client = double(Twitter::REST::Client)
        @tweets = [build(:tweet), build(:tweet)]
        
        expect(ScoreSync).to receive(:new).and_return(@sync)
        expect(Twitter::REST::Client).to receive(:new).and_return(@client)
        expect(@client).to receive(:user_timeline).with("ncaaupdates").and_return(@tweets)
        expect(ScoresSync).to receive(:process_tweet).with("test tweet 1", @sync).twice
        expect(@sync).to receive(:save).once
        
        ScoresSync.perform
        
        expect(@sync.sync_start).not_to be_nil
        expect(@sync.is_successful).to be_truthy
    end
    
    it "should correctly set the client key and secret" do
        client = ScoresSync.set_client
        
        expect(client.credentials[:consumer_key]).not_to be_nil
        expect(client.credentials[:consumer_secret]).not_to be_nil
        expect(client.credentials[:token]).to be_nil
        expect(client.credentials[:token_secret]).to be_nil
    end
    
    describe "processing tweet" do
        
        before :each do 
            @sync = ScoreSync.new
        end
        
        describe "processing a single tweet" do
            
            it "should increment the tweets_found in sync" do
                ScoresSync.process_tweet "test tweet", @sync
            end
            
            it "should do nothing for a blank tweet" do
                ScoresSync.process_tweet "", @sync
                expect(@sync.tweets_used).to eq(0)
            end
            
            it "should do nothing for a nil tweet" do
                ScoresSync.process_tweet nil, @sync
                expect(@sync.tweets_used).to eq(0)
            end
            
            it "should use a final score tweet" do
                tweet = "Western Michigan 58 Eastern Michigan 28 (FINAL) http://goo.gl/fb/CsJq69 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(1)
            end
            
            it "should not use a tweet without a final score" do
                tweet = "Oregon 17 Arizona State 14 (12:28 IN 3RD) http://goo.gl/fb/ybrSr8 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(0)
            end
            
            after :each do
                expect(@sync.tweets_found).to eq(1) 
            end
            
        end
        
        describe "processing multiple tweets" do
            
            it "should process 2 valid tweets" do
                tweet = "Western Michigan 58 Eastern Michigan 28 (FINAL) http://goo.gl/fb/CsJq69 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(1)
                expect(@sync.tweets_found).to eq(1)
                
                tweet = "Texas State 13 Georgia Southern 37 (FINAL) http://goo.gl/fb/TD4Jkt "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(2)
                expect(@sync.tweets_found).to eq(2)
            end
            
            it "should process 1 valid tweet and 1 invalid tweet" do
                tweet = "Western Michigan 58 Eastern Michigan 28 (FINAL) http://goo.gl/fb/CsJq69 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(1)
                expect(@sync.tweets_found).to eq(1)
                
                tweet = "Oregon 17 Arizona State 14 (12:28 IN 3RD) http://goo.gl/fb/ybrSr8 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(1)
                expect(@sync.tweets_found).to eq(2)
            end
            
            it "should process 2 invalid tweets" do
                tweet = "Oregon 10 Arizona State 0 (8:00 IN 2ND) http://goo.gl/fb/AV1y31 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(0)
                expect(@sync.tweets_found).to eq(1)
                
                tweet = "Oregon 17 Arizona State 14 (12:28 IN 3RD) http://goo.gl/fb/ybrSr8 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(0)
                expect(@sync.tweets_found).to eq(2)
            end
            
        end
        
    end
    
    describe "removing unneeded tweet information from example tweets" do
        
        it "should remove game time from parenthesis" do
            text = "Oregon 17 Arizona State 14 (12:28 IN 3RD) http://goo.gl/fb/ybrSr8 "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.include?("(12:28 IN 3RD)")).to be_falsy
        end
        
        it "should remove FINAL from parenthesis" do
            text = "Western Michigan 58 Eastern Michigan 28 (FINAL) http://goo.gl/fb/CsJq69 "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.include?("(FINAL)")).to be_falsy
        end
        
        it "should remove rankings" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.include?("(3)")).to be_falsy
        end
        
        it "should remove extra name information" do
            text = "Buffalo 29 Miami (OH) 24 (FINAL) http://goo.gl/fb/PTlv92 "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.include?("(OH)")).to be_falsy
        end
        
        it "should remove goo.gl links" do
            text = "Buffalo 29 Miami (OH) 24 (FINAL) http://goo.gl/fb/PTlv92 "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.include?("http://goo.gl/fb/PTlv92")).to be_falsy
        end
        
        it "should remove bit.ly links" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.include?("http://bit.ly/1MYh6Do")).to be_falsy
        end
        
        it "should not end with a space" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.end_with?(" ")).to be_falsy
        end
        
        it "should remove final colon from links when it exists" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text.end_with?(":")).to be_falsy
        end
        
        it "should process oregon vs arizona st in 2nd quarter" do
            text = "Oregon 10 Arizona State 0 (8:00 IN 2ND) http://goo.gl/fb/AV1y31 "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text).to eq("Oregon 10 Arizona State 0")
        end
        
        it "should process buffalo vs miami (oh) final" do
            text = "Buffalo 29 Miami (OH) 24 (FINAL) http://goo.gl/fb/PTlv92 "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text).to eq("Buffalo 29 Miami 24")
        end
        
        it "should process WV vs TCU final" do
            text = "West Virginia 10   (3) TCU 40 (FINAL):  http://bit.ly/1MYh6DO "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text).to eq("West Virginia 10 TCU 40")
        end
        
        it "should process western mi vs eastern mi in the 2nd" do
            text = "Western Michigan 51 Eastern Michigan 21 (9:17 IN 4TH) http://goo.gl/fb/zMeXXH "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text).to eq("Western Michigan 51 Eastern Michigan 21")
        end
        
        it "should process WV vs TCU at halftime" do
            text = "West Virginia 10 (3) TCU 23 (HALFTIME) http://goo.gl/fb/2P7K0O "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text).to eq("West Virginia 10 TCU 23")
        end
        
        it "should process game time tweets" do 
            text = "North Carolina at (24) Pittsburgh (THU, OCT 29 7:00 PM ET) http://goo.gl/fb/sTp9UB "
            text = ScoresSync.remove_unneeded_tweet_info text
            expect(text).to eq("North Carolina at Pittsburgh")
        end
        
    end
    
end