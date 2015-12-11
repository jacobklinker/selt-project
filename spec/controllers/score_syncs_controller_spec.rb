require 'rails_helper'
 
describe ScoreSyncsController do
    
    it "should load all score syncs for the index" do
        expect(ScoreSync).to receive(:all)
        post :index
    end
    
    it "should redirect after starting sync from /score_syncs/new" do
        expect(ScoresSync).to receive(:perform)
        league=double(League)
        obj=double(Object)
        allow(League).to receive(:all).and_return(obj)
        allow(obj).to receive(:take).and_return(league)
        allow(league).to receive(:bowlSeason).and_return(false)
        allow(obj).to receive(:each).and_return(nil)
        post :new
        
        expect(response).to redirect_to(score_syncs_path)
        expect(flash[:notice]).to eq("Finished new score sync from Twitter.")
    end
    
    it "should determine a weekly winner on sundays during the year" do
        new_time = Time.local(2015, 12, 6, 10, 0, 0) #SUNDAY after season starts 12/6/2015 
        Timecop.freeze(new_time)
        my_league_pick=double(LeaguePick.create(week: 48))
        league=double(League)
        obj=double(Object)
        allow(League).to receive(:all).and_return(obj)
        allow(obj).to receive(:take).and_return(league)
        allow(league).to receive(:bowlSeason).and_return(false)
        allow(obj).to receive(:each).and_return(nil)
        post :new
        
        expect(response).to redirect_to(score_syncs_path)
        expect(flash[:notice]).to eq("Finished new score sync from Twitter.")
        Timecop.return
    end
     it "should not determine a weekly winner on sundays during bowl season" do
        new_time = Time.local(2015, 12, 27, 10, 0, 0) #SUNDAY after season starts 12/6/2015 
        Timecop.freeze(new_time)
        my_league_pick=double(LeaguePick.create(week: 48))
        league=double(League)
        obj=double(Object)
        allow(League).to receive(:all).and_return(obj)
        allow(obj).to receive(:take).and_return(league)
        allow(league).to receive(:bowlSeason).and_return(true)
        allow(obj).to receive(:each).and_return(nil)
        post :new
        
        expect(response).to redirect_to(score_syncs_path)
        expect(flash[:notice]).to eq("Finished new score sync from Twitter.")
        Timecop.return
    end
    it "should determine a weekly winner on January 15th" do
        new_time = Time.local(2016, 1, 15, 10, 0, 0) #SUNDAY after season starts 12/6/2015 
        Timecop.freeze(new_time)
        my_league_pick=double(LeaguePick.create(week: 48))
        league=double(League)
        obj=double(Object)
        allow(League).to receive(:all).and_return(obj)
        allow(obj).to receive(:take).and_return(league)
        allow(league).to receive(:bowlSeason).and_return(true)
        allow(obj).to receive(:each).and_return(nil)
        post :new
        
        expect(response).to redirect_to(score_syncs_path)
        expect(flash[:notice]).to eq("Finished new score sync from Twitter.")
        Timecop.return
    end
end