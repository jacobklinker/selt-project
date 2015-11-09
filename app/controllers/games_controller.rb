# Used to simply display a list of all games in the database for administrator
# purposes. This is not end user facing.
class GamesController < ApplicationController
    
    def game_params
        params.require(:game).permit(:home_score, :away_score, :is_finished)
    end
    
    def index
        @games = Game.all
    end
    
    def edit
        @game = Game.find params[:id]
    end
    
    def update
        @game = Game.find params[:id]
        @game.update_attributes!(game_params)
        flash[:notice] = "#{@game.home_team} vs #{@game.away_team} was successfully updated."
        redirect_to games_path
    end
    
end