# Used to simply display a list of all games in the database for administrator
# purposes. This is not end user facing.
class GamesController < ApplicationController
    
    def index
        @games = Game.all
    end
    
end