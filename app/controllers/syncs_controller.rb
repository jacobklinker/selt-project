class SyncsController < ApplicationController
    
    def index
        @syncs = Sync.all
    end
    
    def new
        GamesSync.perform
        flash[:notice] = "Finished new sync."
        redirect_to action: "index"
    end
    
end