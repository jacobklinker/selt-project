class LeaguePick < ActiveRecord::Base
    has_one :user
    has_one :league
    
    def self.calculateScores
        
        week = ((Time.now.strftime('%U').to_i)-1)
        
        #Need to delete
        week=week+1
        #
        @league_picks = LeaguePick.where(week: week).find_each


        @league_picks.each do |league_pick|
        
            @picks = Pick.where(league_pick_id: league_pick.id).find_each
            @games = []
            
            @picks.each do |pick|
                game = Game.find(pick.game_id)
                @games << {
                    :game => game, 
                    :home_winner => pick.home_wins,
                    :home_team_cover => game.homeTeamCover
                }
            end
            wins=0;
            losses=0;
            pushes=0;
            @games.each do |game|
                if((game[:home_winner]==true && game[:home_team_cover]==2) || (game[:home_winner]==false && game[:home_team_cover]==0) )
                    wins=wins+1
                    puts "win"
                    puts game
                elsif(game[:home_team_cover]==1)
                    pushes=pushes+1
                elsif((game[:home_winner]==true && game[:home_team_cover]==0) || (game[:home_winner]==false && game[:home_team_cover]==2))
                    losses=losses+1
                    puts "loss"
                    puts game
                end
            end
            
            league_pick[:wins]=wins
            league_pick.losses=losses
            league_pick.pushes=pushes
            league_pick.save!
        end
        
        League.all.each do |league|
            @league_picks=LeaguePick.where(league_id: league.id, week: week).find_each
            score=0;
            @league_picks.each do |league_pick|
                score=((league_pick.wins)*2) + league_pick.pushes
                puts "Score"
                puts league_pick.user_id
                puts score
            end
        end
        
        
    end
end