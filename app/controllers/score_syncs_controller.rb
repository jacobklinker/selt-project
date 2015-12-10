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
        if (Time.now.in_time_zone("Central Time (US & Canada)").wday == 0 &&  !WeeklyWinner.where(week: week).any?) #If Sunday & no weeklywinners for this week
            if(LeaguePick.where(week: (week-1)).any?)
                LeaguePick.calculateScores
                WeeklyWinner.determine_weekly_winners
            end
        end
        #Where this will go-- Game.home_team_cover
       # day = ((Time.now.strftime('%w').to_i))
        #hour = ((Time.now.strftime('%H').to_i))
        #min = ((Time.now.strftime('%M').to_i))
        #if (day==0 && hour==1 && min <=14)
        #    Game.home_team_cover
        #LeaguePick.calculateScores
        #    WeeklyWinner.determine_weekly_winners
        #end
        redirect_to action: "index"
    end
    
    def manualUpdate
        Game.home_team_cover
        LeaguePick.calculateScores
        WeeklyWinner.determine_weekly_winners
        redirect_to action:"index"
    end
    
end