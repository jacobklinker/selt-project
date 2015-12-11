describe LeaguePick do
    
    describe "League has picks made for week" do
        it "should be associated with LeaguePicks that have been made" do
            my_league = double(LeaguePick)
            expect(LeaguePick.where(:league_id => 1, :week => Time.now.strftime('%U')))
                #League.where(league_name: "League1", commissioner_id: 1, conference_settings: "FBS", number_picks_settings: 5 )).to exist
        end
        
        it "should not have any picks made for league" do
            expect(League.where(league_name: "League1", commissioner_id: 1, conference_settings: "FBS", number_picks_settings: 5 )).not_to exist
        end
    end
    
    describe "A member has made a pick" do
        it "should know a pick has been make for that league this week" do
            week = ((Time.now.strftime('%U').to_i)-1)
            my_league = double(League)
            pickMade=LeaguePick.where(:league_id => 1, :week => week)
            allow(my_league).to receive(:id).and_return(1)
            expect(LeaguePick).to receive(:where).and_return(pickMade)
            LeaguePick.member_has_picked(my_league)
        end
    end
    
    describe "Calculate the scores" do
        describe "should update all league picks"
            it "when league pick is correct" do
                week = ((Time.now.strftime('%U').to_i)-1)
                
                my_game=game=double(Game.create(homeTeamCover: 2, is_finished: true, home_score: 20, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
                my_pick = double(Pick.create(game_id: 1, league_pick_id: 1, home_wins: true))
                my_league_pick=double(LeaguePick.create(week: week))
                
                league_picks=LeaguePick.where(:week => week)
                allow(LeaguePick).to receive(:where).with(week: week).and_return(league_picks)
                allow(my_pick).to receive(:game_id).and_return(1)
                expect(Game).to receive(:find).with(1).and_return(my_game)
                
                expect(my_game).to receive(:homeTeamCover).and_return(2)
                allow(my_pick).to receive(:home_wins).and_return(true)


                my_league=double(League.create(id:1))
                allow(LeaguePick).to receive(:where).with(league_id: 1, week: week).and_return(league_picks)
                
                LeaguePick.calculateScores
    
            end
            
            it "when league pick is incorrect" do
                week = ((Time.now.strftime('%U').to_i)-1)
                
                my_game=game=double(Game.create(homeTeamCover: 2, is_finished: true, home_score: 20, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
                my_pick = double(Pick.create(game_id: 1, league_pick_id: 1, home_wins: false))
                my_league_pick=double(LeaguePick.create(week: week))
                
                league_picks=LeaguePick.where(:week => week)
                expect(LeaguePick).to receive(:where).and_return(league_picks)
                allow(my_pick).to receive(:game_id).and_return(1)
                expect(Game).to receive(:find).with(1).and_return(my_game)
                
                expect(my_game).to receive(:homeTeamCover).and_return(2)
                allow(my_pick).to receive(:home_wins).and_return(false)

                my_league=double(League.create(id:1))
                allow(LeaguePick).to receive(:where).with(league_id: 1, week: week).and_return(league_picks)
                
                LeaguePick.calculateScores
    
            end
            
            it "when league pick is push" do
                week = ((Time.now.strftime('%U').to_i)-1)
                
                my_game=game=double(Game.create(homeTeamCover: 2, is_finished: true, home_score: 20, away_score: 10, home_odds: -3, away_odds: 3, home_team: "Iowa", away_team: "Stanford"))
                my_pick = double(Pick.create(game_id: 1, league_pick_id: 1, home_wins: false))
                my_league_pick=double(LeaguePick.create(week: week))
                
                league_picks=LeaguePick.where(:week => week)
                expect(LeaguePick).to receive(:where).and_return(league_picks)
                allow(my_pick).to receive(:game_id).and_return(1)
                expect(Game).to receive(:find).with(1).and_return(my_game)
                
                expect(my_game).to receive(:homeTeamCover).and_return(1)
                allow(my_pick).to receive(:home_wins).and_return(true)


                my_league=double(League.create(id:1))
                allow(LeaguePick).to receive(:where).with(league_id: 1, week: week).and_return(league_picks)
                
                LeaguePick.calculateScores
    
            end
            
    end
end