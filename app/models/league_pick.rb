class LeaguePick < ActiveRecord::Base
    has_one :user
    has_one :league
    
    
    def self.member_has_picked(league)
    
        @league=league
        pickMade=LeaguePick.where(:league_id => @league.id, :week => Time.now.strftime('%U'))
        
        pickMade.exists?
    end
end