class LeaguePick < ActiveRecord::Base
    has_one :user
    has_one :league
    
    def self.calculateScores
        LeaguePick.all.each do |league|
            if(league.league_id==1)
                Pick.all.each do |picks|
                    if(picks.league_pick_id==1)
                        puts picks.id
                    end
                end
            end
        end
    end
end