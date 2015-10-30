require 'rails_helper'
 
describe SyncsController do
    
    it "should load all syncs for the index" do
        expect(Sync).to receive(:all)
        post :index
    end
    
    it "should redirect after starting sync from /syncs/new" do
        expect(GamesSync).to receive(:perform)
        
        post :new
        
        expect(response).to redirect_to(syncs_path)
        expect(flash[:notice]).to eq("Finished new sync.")
    end
    
end