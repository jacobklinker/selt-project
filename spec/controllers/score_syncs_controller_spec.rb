require 'rails_helper'
 
describe ScoreSyncsController do
    
    it "should load all score syncs for the index" do
        expect(ScoreSync).to receive(:all)
        post :index
    end
    
    it "should redirect after starting sync from /score_syncs/new" do
        expect(ScoresSync).to receive(:perform)
        
        post :new
        
        expect(response).to redirect_to(score_syncs_path)
        expect(flash[:notice]).to eq("Finished new score sync from Twitter.")
    end
    
end