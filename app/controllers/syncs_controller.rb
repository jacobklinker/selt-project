# Used to simply display a list of all syncs in the database for administrator
# purposes. This is not end user facing.
#
# It can also be used to manually force a new sync to occur.
class SyncsController < ApplicationController
    
    skip_before_filter :authenticate_user!, :only => [:new]
    
    def index
        @syncs = Sync.all
    end
    
    def new
        GamesSync.perform
        flash[:notice] = "Finished new sync."
        redirect_to action: "index"
    end
    
end