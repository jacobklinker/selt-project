require 'rails_helper'

describe Tiebreaker do
    it "randomly assigns tiebreakers after Wednesday" do
        new_time = Time.local(2015, 12, 10, 10, 0, 0) #SUNDAY after season starts 12/6/2015 
        Timecop.freeze(new_time)
        week = Time.now.strftime("%U")
        obj = double(Object)
        int = double(Integer)
        
        league_with_tiebreaker = League.new(:id => 1)
        league_without_tiebreaker = League.new(:id => 2)
        
        game1=Game.new(:id => 1.to_i, :game_time => Time.local(2015, 12, 20, 10, 0, 0))
        game2=Game.new(:id => 2.to_i, :game_time => Time.local(2015, 12, 23, 10, 0, 0))
        
        tiebreaker = Tiebreaker.new(:league_id => 2, :week => week)
        
        expect(Tiebreaker).to receive(:where).with(week: week).and_return([tiebreaker])
        expect(League).to receive(:all).and_return([league_with_tiebreaker, league_without_tiebreaker])
        expect(Game).to receive(:all).and_return([game1, game2])
        expect(Random).to receive(:new).and_return(obj)
        allow(obj).to receive(:rand).and_return(0)
        allow(obj).to receive(:rand).and_return(1)
        expect(Tiebreaker).to receive(:create).with(:league_id => 1, :week => week, :game_id => 2).and_return(obj)
        
        Tiebreaker.set_default_tiebreaker
        Timecop.return
    end
end