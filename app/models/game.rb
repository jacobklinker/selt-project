# Contains all information pertaining to Games saved in the database from 
# Pinnacle Sports.
class Game < ActiveRecord::Base
    
    def self.home_team_cover
        Game.all.each do |game|
            if (game.home_score != nil) then
                if((game.home_score+game.home_odds)==game.away_score)
                    game.homeTeamCover=1
                elsif ((game.home_score+game.home_odds)>game.away_score)
                    game.homeTeamCover=2
                else
                    game.homeTeamCover=0
                end
            end
            game.save!
        end
    end
end