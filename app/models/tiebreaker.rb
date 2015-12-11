class Tiebreaker < ActiveRecord::Base
    has_one :league
    has_one :game
    
    def self.set_default_tiebreaker
        if (Time.now.in_time_zone("Central Time (US & Canada)").wday >= 3)
            week = Time.now.in_time_zone("Central Time (US & Canada)").strftime("%U")
            tiebreakers = Tiebreaker.where(week: week)
            
            leagues_with_tiebreaker = []
            tiebreakers.each do |tiebreaker|
                leagues_with_tiebreaker << tiebreaker.league_id
            end
            
            leagues_without_tiebreaker = []
            
            all_leagues = League.all
            
            all_leagues.each do |league|
                id = league.id
                
                if !leagues_with_tiebreaker.include?(id)
                    leagues_without_tiebreaker << id
                end
            end
            
            #allGames = Game.all
            futureGames = []
            #allGames.each do |game|
            Game.all.each do |game|
                if Time.now.in_time_zone("Central Time (US & Canada)") < game.game_time.in_time_zone("Central Time (US & Canada)")
                    futureGames.push(game)
                end
            end
            
            r = Random.new
            max = futureGames.size
            
            if max != 0
                leagues_without_tiebreaker.each do |league|
                    index = r.rand(0...max-1)
                    game = futureGames[index]
                    Tiebreaker.create(:league_id => league, :week => week, :game_id => game.id)
                end
            end
        end
    end
end