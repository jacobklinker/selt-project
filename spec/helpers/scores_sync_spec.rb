require 'rails_helper'

describe "scores background sync" do
    
    it "should save a score sync object" do
        @sync = ScoreSync.new
        @client = double(Twitter::REST::Client)
        @tweets = [build(:tweet), build(:tweet)]
        
        expect(ScoreSync).to receive(:new).and_return(@sync)
        expect(Twitter::REST::Client).to receive(:new).and_return(@client)
        expect(@client).to receive(:user_timeline).with("ncaaupdates", :count => 100).and_return(@tweets)
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
            @game = Game.new
            where = double([])
            allow(Game).to receive(:where).and_return(where)
            allow(where).to receive(:last).and_return(@game)
            allow(@game).to receive(:save)
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
                expect(@game.home_score).to eq(28)
                expect(@game.away_score).to eq(58)
                expect(@game.is_finished).to be_truthy
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
                expect(@game.home_score).to eq(28)
                expect(@game.away_score).to eq(58)
                expect(@game.is_finished).to be_truthy
                
                tweet = "Texas State 13 Georgia Southern 37 (FINAL) http://goo.gl/fb/TD4Jkt "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(2)
                expect(@sync.tweets_found).to eq(2)
                expect(@game.home_score).to eq(37)
                expect(@game.away_score).to eq(13)
                expect(@game.is_finished).to be_truthy
            end
            
            it "should process 1 valid tweet and 1 invalid tweet" do
                tweet = "Western Michigan 58 Eastern Michigan 28 (FINAL) http://goo.gl/fb/CsJq69 "
                ScoresSync.process_tweet tweet, @sync
                expect(@sync.tweets_used).to eq(1)
                expect(@sync.tweets_found).to eq(1)
                expect(@game.home_score).to eq(28)
                expect(@game.away_score).to eq(58)
                expect(@game.is_finished).to be_truthy
                
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
    
end