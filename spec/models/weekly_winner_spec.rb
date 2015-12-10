require 'rails_helper'

#describe WeeklyWinner do
    #describe "Calling determine weekly winners" do
    
        #it "will create weekly winners object" do
        #    week_winners = WeeklyWinner.create(:league_id => 1, :week => 50, :year => 2015, :winners => [3]) 
        #    week = ((Time.now.strftime('%U').to_i)-1)
        #    year = Time.now.strftime('%Y').to_i
        #    league1=double(League.create(:id =>1))
         #   league2=double(League.create(:id =>2))
         #   leaguePick1=double(LeaguePick.create(:id =>1, :league_id => 1, :week => 49))
        #    leaguePick2=double(LeaguePick.create(:id =>2, :league_id => 1, :week => 49))
        #    
        #    league_picks = [leaguePick1, leaguePick2]
        #    where_pick=double(Object)
            
        #    expect(LeaguePick).to receive(:where).with(league_id: 1, week: week).and_return(where_pick)
        #    expect(where_pick).to receive(:find_each).and_return(league_picks)
            
        #    league_picks = LeaguePick.where(league_id: 2, week: week).find_each
        #    puts league_picks
            #expect(league_picks).to receive(:next_values).and_return(leaguePick1)
            
            #allow(@league_picks).to receive(:any?).and_return(true)
            
            #@league_picks=LeaguePick.where(league_id: 1, week: 49).find_each
            
            
         #   WeeklyWinner.determine_weekly_winners
        #    expect(WeeklyWinner).to receive(:find).with(1).and_return(week_winners)
#        end
#    end 
    
    #describe "removing unneeded tweet information from example tweets" do
     #   
      #  it "should remove game time from parenthesis" do
       #     text = "Oregon 17 Arizona State 14 (12:28 IN 3RD) http://goo.gl/fb/ybrSr8 "
        #    text = GameTweet.remove_unneeded_tweet_info text
        #    expect(text.include?("(12:28 IN 3RD)")).to be_falsy
        #end
    #end 
    
      #  pick1 = Pick.new(:game_id => 1, :home_wins => true)
      #  pick2 = Pick.new(:game_id => 2, :home_wins => false)
      #  week = Time.now.strftime('%U')
        #@tiebreaker = Tiebreaker.new(:id => 1, :game_id => 1, :league_id => 1, :week => week.to_i)
      #  picks = [pick1, pick2]
      #  where_pick = double(Object)
      #  expect(Pick).to receive(:where).with(league_pick_id: 1).and_return(where_pick)
      #  expect(where_pick).to receive(:find_each).and_return(picks)
#end