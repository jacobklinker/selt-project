require 'rails_helper'

describe Game do
    describe "Calling determine home_team_cover" do
    
        it "will determine that the home team covered" do
            game=double(Game.create(is_finished: true, home_score: 20, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
            puts game
            Game.home_team_cover
            puts game
            expect(game).to have_attributes(:homeTeamCover => 1)
            #allow(game).to receive(:save!)
            puts game
            
        end
    end 
end