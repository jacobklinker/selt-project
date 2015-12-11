# Used to simply display a list of all score syncs in the database for administrator
# purposes. This is not end user facing.
#
# It can also be used to manually force a new score sync to occur.
class ScoreSyncsController < ApplicationController
    
    skip_before_filter :authenticate_user!, :only => [:new]
    
    def index
        @syncs = ScoreSync.all
        
    end
    
    def new
        ScoresSync.perform
        Game.home_team_cover
        Tiebreaker.set_default_tiebreaker
        
        flash[:notice] = "Finished new score sync from Twitter."
        
        week = Time.now.in_time_zone("Central Time (US & Canada)").strftime("%U").to_i
        
        allGames = Game.all
        futureGames = []
        allGames.each do |game|
            if Time.now.utc < game.game_time.utc
                futureGames.push(game)
            end
        end
        futureGames.each do |game|
            if((game.home_team=="Army" && game.away_team=="Navy") || (game.home_team=="Navy" && game.away_team=="Army"))
                League.all.each do |league|
                    league.bowlSeason=true
                    league.save!
                end
            end
        end
        
        test_league=League.all.take
        if(test_league.bowlSeason==false)
            if (Time.now.in_time_zone("Central Time (US & Canada)").wday == 0 &&  !WeeklyWinner.where(week: week).any?) #If Sunday & no weeklywinners for this week
                if(LeaguePick.where(week: (week-1)).any?)
                    LeaguePick.calculateScores
                    WeeklyWinner.determine_weekly_winners
                end
            end
        elsif (Time.now.in_time_zone("Central Time (US & Canada)").strftime("%j").to_i ==15)
            LeaguePick.calculateScores
            WeeklyWinner.determine_weekly_winners
            League.all.each do |league|
                    league.bowlSeason=false
                    league.save!
                end
        end
        redirect_to action: "index"
    end
    
    #def manualUpdate
    #    Game.home_team_cover
    #    LeaguePick.calculateScores
    #    WeeklyWinner.determine_weekly_winners
    #    redirect_to action:"index"
    #end
    
end