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
            my_league = double(League)
            pickMade=LeaguePick.where(:league_id => 1, :week => Time.now.strftime('%U'))
            allow(my_league).to receive(:id).and_return(1)
            expect(LeaguePick).to receive(:where).and_return(pickMade)
            LeaguePick.member_has_picked(my_league)
        end
        
    end
end