require 'rails_helper'

describe WeeklyWinner do
    describe "Calling determine weekly winners" do
    
        it "will create weekly winners object with a single winner via wins" do
            league1=double(League.create(:id =>1))
            league_pick=double(LeaguePick.create(league_id: 1, week: 48, wins: 5, user_id: 1))
            league_pick2=double(LeaguePick.create(league_id: 1, week: 48, wins: 6, user_id: 2))
            user1=double(User)
            user2=double(User)
            
            league_picks=LeaguePick.where(league_id: 1, week: 48)
            expect(LeaguePick).to receive(:where).and_return(league_picks)
            
            allow(User).to receive(:find).with(1).and_return(user1)
            allow(User).to receive(:find).with(2).and_return(user2)

            WeeklyWinner.determine_weekly_winners
            
            expect(WeeklyWinner.find(1).winners).to eq [2]
        end
        
        it "will create weekly winners object with one winner via pushes" do
            league1=double(League.create(:id =>1))
            league_pick=double(LeaguePick.create(league_id: 1, week: 48, wins: 6, pushes: 0, user_id: 1))
            league_pick2=double(LeaguePick.create(league_id: 1, week: 48, wins: 6, pushes: 1, user_id: 2))
            league_pick2=double(LeaguePick.create(league_id: 1, week: 48, wins: 6, pushes: 2, user_id: 3))
            user1=double(User)
            user2=double(User)
            user3=double(User)
            
            league_picks=LeaguePick.where(league_id: 1, week: 48)
            expect(LeaguePick).to receive(:where).and_return(league_picks)
            
            allow(User).to receive(:find).with(1).and_return(user1)
            allow(User).to receive(:find).with(2).and_return(user2)
            allow(User).to receive(:find).with(3).and_return(user3)
            
            WeeklyWinner.determine_weekly_winners
            
            expect(WeeklyWinner.find(1).winners).to eq [3]
        end
        
        it "will create weekly winners object with one winner via tiebreaker" do
            league1=double(League.create(:id =>1))
            league_pick=double(LeaguePick.create(league_id: 1, week: 48, wins: 6, pushes: 2, user_id: 1))
            league_pick2=double(LeaguePick.create(league_id: 1, week: 48, wins: 6, pushes: 2, user_id: 2))
            user1=double(User)
            user2=double(User)
            
            tiebreaker1=double(TiebreakerPick.create(points_estimate: 30, game_id: 1, league_pick_id: 1))
            tiebreaker2=double(TiebreakerPick.create(points_estimate: 40, game_id: 1, league_pick_id: 2))
            
            league_picks=LeaguePick.where(league_id: 1, week: 48)
            allow(LeaguePick).to receive(:where).and_return(league_picks)
            
            allow(User).to receive(:find).with(1).and_return(user1)
            allow(User).to receive(:find).with(2).and_return(user2)
            
            challengingTiebreaker1=TiebreakerPick.where(league_pick_id: 1)
            challengingTiebreaker2=TiebreakerPick.where(league_pick_id: 2)
            
            allow(TiebreakerPick).to receive(:where).with(league_pick_id: 1).and_return(challengingTiebreaker1)
            allow(TiebreakerPick).to receive(:where).with(league_pick_id: 2).and_return(challengingTiebreaker2)
            
            allow(challengingTiebreaker1).to receive(:take).and_return(tiebreaker1)
            allow(challengingTiebreaker1).to receive(:take).and_return(tiebreaker2)
            allow(challengingTiebreaker2).to receive(:take).and_return(tiebreaker1)
            allow(challengingTiebreaker2).to receive(:take).and_return(tiebreaker2)
            
            leader_league_pick=LeaguePick.where(user_id: 1, week: 48, league_id: 1)
            leader_league_pick2=LeaguePick.where(user_id: 2, week: 48, league_id: 1)
            allow(LeaguePick).to receive(:where).with(user_id: 1, week: 48, league_id: 1).and_return(leader_league_pick)
            allow(LeaguePick).to receive(:where).with(user_id: 1, week: 48, league_id: 1).and_return(leader_league_pick2)
            allow(LeaguePick).to receive(:where).with(user_id: 2, week: 48, league_id: 1).and_return(leader_league_pick)
            allow(LeaguePick).to receive(:where).with(user_id: 2, week: 48, league_id: 1).and_return(leader_league_pick2)
            
            allow(TiebreakerPick).to receive(:where).with(league_pick_id: leader_league_pick).and_return(leader_league_pick)
            allow(TiebreakerPick).to receive(:where).with(league_pick_id: leader_league_pick).and_return(leader_league_pick2)
            allow(TiebreakerPick).to receive(:where).with(league_pick_id: leader_league_pick2).and_return(leader_league_pick2)
            allow(TiebreakerPick).to receive(:where).with(league_pick_id: leader_league_pick2).and_return(leader_league_pick)
            
            allow(leader_league_pick).to receive(:take).and_return(tiebreaker1)
            allow(leader_league_pick).to receive(:take).and_return(tiebreaker2)
            allow(leader_league_pick2).to receive(:take).and_return(tiebreaker1)
            allow(leader_league_pick2).to receive(:take).and_return(tiebreaker2)
            
            my_game=game=double(Game.create(homeTeamCover: 2, is_finished: true, home_score: 20, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
            
            allow(tiebreaker1).to receive(:game_id).and_return(1)
            allow(tiebreaker2).to receive(:game_id).and_return(1)
            
            allow(Game).to receive(:find).with(1).and_return(my_game)
            allow(my_game).to receive(:home_score).and_return(20)
            allow(my_game).to receive(:away_score).and_return(10)
            
            allow(tiebreaker1).to receive(:points_estimate).and_return(30)
            allow(tiebreaker2).to receive(:points_estimate).and_return(40)
            
            
            
            #allow(TiebreakerPick).to receive(:where).with(league_pick_id: 1).and_return(tiebreaker1)
            #allow(TiebreakerPick).to receive(:where).with(league_pick_id: 2).and_return(tiebreaker2)

            #tiebroke1=LeaguePick.where(user_id: 1, week: 48, league_id: 1)
            #tiebroke2=LeaguePick.where(user_id: 2, week: 48, league_id: 1)

            allow(league_pick).to receive(:id).and_return(1)
            allow(league_pick2).to receive(:id).and_return(2)
            
            #allow(LeaguePick).to receive(:where).with(user_id: 1, week: 48, league_id: 1).and_return(tiebroke1)
            #allow(LeaguePick).to receive(:where).with(user_id: 2, week: 48, league_id: 1).and_return(tiebroke2)
            
            #allow(TiebreakerPick).to receive(:where).with(league_pick_id: 1).and_return(tiebreaker1)
            #allow(TiebreakerPick).to receive(:where).with(league_pick_id: 2).and_return(tiebreaker2)

            WeeklyWinner.determine_weekly_winners
            
            #expect(WeeklyWinner.find(1).winners).to eq [3]
        end
    end 
end