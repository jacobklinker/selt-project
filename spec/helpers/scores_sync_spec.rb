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
    
    it "should set correct client key and secret" do
        client = ScoresSync.set_client
        
        expect(client.credentials[:consumer_key]).not_to be_nil
        expect(client.credentials[:consumer_secret]).not_to be_nil
        expect(client.credentials[:token]).to be_nil
        expect(client.credentials[:token_secret]).to be_nil
    end
    
    describe "processing tweet" do
        
        before :each do 
            @sync = ScoreSync.new
            @tweet = Tweet.new
        end
       
        it "should increment the tweets_found in sync" do
            @tweet.text = "test tweet"
            
            ScoresSync.process_tweet @tweet, @sync
            
            expect(@sync.tweets_found).to eq(1)
        end
        
    end
    
end