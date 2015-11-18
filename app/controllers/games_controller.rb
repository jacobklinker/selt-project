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
    
    def picks
        allGames = Game.all
        @games = []
        allGames.each do |game|
            if Time.now.utc < game.game_time.utc
                @games.push(game)
            end
        end
        @league_id = params[:league_id]
    end
    
    def submit_picks
        league = League.find(params[:league_id])
        picks = params[:picks]
        user = current_user
        week = Time.now.strftime('%U')
        
        league_pick = LeaguePick.create(:league_id => league.id, :user_id => user.id, :week => week)
        picks.each do |game_id, team_name|
            game = Game.find(game_id)
            Pick.create(:game_id => game.id, :league_pick_id => league_pick.id, :home_wins => game.home_team == team_name)
        end
        
        flash[:notice] = "Picks saved successfully!"
        redirect_to league_path(league)
    end
    
    def show_picks
        league = League.find(params[:league_id])
        user = User.find(params[:user_id])
        week = Time.now.strftime('%U')
        
        @league_pick = LeaguePick.where(league_id: league.id, user_id: user.id, week: week).take
        
        if @league_pick == nil 
            render "games/no_picks"
            return
        end
        
        @picks = Pick.where(league_pick_id: @league_pick.id).find_each
        @games = []
        
        @picks.each do |pick|
            game = Game.find(pick.game_id)
            @games << {
                :game => game, 
                :home_winner => pick.home_wins
            }
        end
    end
    
end