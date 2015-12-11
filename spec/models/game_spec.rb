require 'rails_helper'

describe Game do
    describe "Calling determine home_team_cover" do
    
        it "will determine that the home team covered" do
            game=double(Game.create(homeTeamCover: nil, is_finished: true, home_score: 20, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
            Game.home_team_cover
            allow(game).to receive(:homeTeamCover).and_return 2
        end
        
        it "will determine that the home team did not" do
            game=double(Game.create(homeTeamCover: nil, is_finished: true, home_score: 12, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
            Game.home_team_cover
            allow(game).to receive(:homeTeamCover).and_return 0
        end
        
        it "will determine that there was a push" do
            game=double(Game.create(homeTeamCover: nil, is_finished: true, home_score: 13, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
            Game.home_team_cover
            allow(game).to receive(:homeTeamCover).and_return 1
        end
    end 
end