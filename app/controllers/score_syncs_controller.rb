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
        flash[:notice] = "Finished new score sync from Twitter."
        #Where this will go-- Game.home_team_cover
        day = ((Time.now.strftime('%w').to_i))
        hour = ((Time.now.strftime('%H').to_i))
        min = ((Time.now.strftime('%M').to_i))
        if (day==0 && hour==1 && min <=14)
            Game.home_team_cover
            LeaguePick.calculateScores
            WeeklyWinner.determine_weekly_winners
        end
        redirect_to action: "index"
    end
    
end