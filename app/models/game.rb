# Contains all information pertaining to Games saved in the database from 
# Pinnacle Sports.
class Game < ActiveRecord::Base
    
    def self.home_team_cover
        Game.all.each do |game|
            if ((game.home_team=="Iowa" || game.away_team=="Iowa") && game.home_score != nil)
                if((game.home_score+game.home_odds)>game.away_score)
                    game.homeTeamCover=true
                else
                    game.homeTeamCover=false
                end
            puts game.home_team
            puts game.homeTeamCover
            end
        end
    end
end