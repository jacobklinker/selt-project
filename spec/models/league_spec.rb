describe League do
    
    describe "League added to database" do
        it "should exist in database" do
            my_league = League.create(:league_name => "League1", :commissioner_id => 1, :conference_settings => "FBS", :number_picks_settings => 5) 
            expect(League.where(league_name: "League1", commissioner_id: 1, conference_settings: "FBS", number_picks_settings: 5 )).to exist
        end
    end
    
end