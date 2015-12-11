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
    
    it "should determine a weekly winner on sundays during the year" do
        new_time = Time.local(2015, 12, 6, 10, 0, 0) #SUNDAY after season starts 12/6/2015 
        Timecop.freeze(new_time)
        my_league_pick=double(LeaguePick.create(week: 48))
        
        post :new
        
        expect(response).to redirect_to(score_syncs_path)
        expect(flash[:notice]).to eq("Finished new score sync from Twitter.")
        Timecop.return
    end
end