# Used to simply display a list of all score syncs in the database for administrator
# purposes. This is not end user facing.
#
# It can also be used to manually force a new score sync to occur.
class ScoreSyncsController < ApplicationController
    
    skip_before_filter :authenticate_user!, :only => [:new]
    
    def index
        @syncs = ScoreSync.all
        Game.home_team_cover
        puts "Ready to calculate"
        LeaguePick.calculateScores
    end
    
    def new
        ScoresSync.perform
        flash[:notice] = "Finished new score sync from Twitter."
        #Where this will go-- Game.home_team_cover
        redirect_to action: "index"
    end
    
end