require 'rails_helper'

describe Tweet do
    
    describe 'instantiation' do
        let!(:tweet) { build(:tweet) }
    
        it 'instantiates a tweet' do
            expect(tweet.class.name).to eq("Tweet")
        end
    end
    
end