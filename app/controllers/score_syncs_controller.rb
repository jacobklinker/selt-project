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
        redirect_to action: "index"
    end
    
end