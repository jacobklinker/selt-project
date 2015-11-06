require 'rails_helper'
 
describe GamesController do
    
    it "should load all games for the index" do
        expect(Game).to receive(:all)
        post :index
    end
    
    describe "updating a game" do
        
        before :each do
            @game = double(Game)
            expect(Game).to receive(:find).with("1").and_return(@game)
        end
        
        it "should load a single game for editing" do
            post :edit, {:id => 1}
        end
        
        it "should load a single game for updating" do
            expect(@game).to receive(:update_attributes!).once
            expect(@game).to receive(:home_team).and_return("Indiana")
            expect(@game).to receive(:away_team).and_return("Iowa")
            post :update, {:id => 1, :game => {:home_score => 0, :away_score => 10, :is_finished => true}}
            expect(flash[:notice]).to eq("Indiana vs Iowa was successfully updated.")
            expect(response).to redirect_to(games_path)
        end
        
    end
    
end