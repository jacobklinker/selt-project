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
        league = League.find(params[:league_id])
        @num_picks = league.number_picks_settings;
        allGames = Game.all
        futureGames = []
        allGames.each do |game|
            if Time.now.utc < game.game_time.utc
                futureGames.push(game)
            end
        end
        @league_id = params[:league_id]
        
        conference = league.conference_settings;
        games = []
        @games = []
        case conference
            when "SEC"
                teams = ["Alabama", "Arkansas", "Auburn", "Florida", "Georgia", "Kentucky", "LSU", "Mississippi St", "Missouri", "Mississippi", "South Carolina", "Tennessee U", "Texas A&M", "Vanderbilt"]
            when "Big 10"
                teams = ["Ohio State", "Michigan State", "Michigan", "Penn State", "Rutgers", "Indiana", "Maryland", "Iowa", "Wisconsin", "Northwestern", "Nebraska", "Illinois", "Minnesota U", "Purdue"]
            when "Big 12"
                teams = ["Oklahoma State", "Oklahoma", "TCU", "Baylor", "Texas", "Texas Tech", "West Virginia", "Iowa State", "Kansas State", "Kansas"]
            when "ACC"
                teams = ["Clemson", "Florida State", "Louisville", "NC State", "Syracuse", "Wake Forest", "Boston College", "North Carolina", "Pittsburgh U", "Miami Florida", "Duke", "Virginia Tech", "Virginia", "Georgia Tech"]
            when "American Athletic Conference"
                teams = ["Temple", "South Florida", "Cincinnati U", "Connecticut", "East Carolina", "UCF", "Houston", "Navy", "Memphis", "Tulsa", "Tulane", "SMU"]
            when "Conference USA"
                teams = ["Western Kentucky", "Marshall", "Middle Tennessee St", "Old Dominion", "Florida Intl", "Florida Atlantic", "Charlotte", "Louisiana Tech", "Southern Mississippi", "UTEP", "Rice", "Texas San Antonio", "North Texas"]
            when "Mid-American Conference"
                teams = ["Bowling Green", "Bowling Green", "Buffalo U", "Akron", "Kent State", "Massachusetts", "Miami Ohio", "Toledo", "Northern Illinois", "Western Michigan", "Central Michigan", "Ball State", "Eastern Michigan"]
            when "Mountain West Conference"
                teams = ["Air Force", "Boise State", "New Mexico", "Utah State", "Colorado State", "Wyoming", "San Diego State", "Nevada", "San Jose State", "UNLV", "Fresno State", "Hawaii"]
            when "PAC 12"
                teams = ["Stanford", "Oregon", "Washington State", "California", "Washington U", "Oregon State", "Utah", "USC", "UCLA", "Arizona State", "Arizona", "Colorado"]
            when "Sun Belt"
                teams = ["Arkansas State", "Appalachian State", "Georgia Southern", "South Alabama", "UL Lafayette", "Georgia State", "New Mexico State", "Troy", "Idaho", "Texas State", "UL Monroe"]
        end
        
        if conference == "FBS"
            @games = futureGames
        else
            futureGames.each do |game|
                teams.each do |team|
                    if game.home_team == team or game.away_team == team
                        games.push(game)
                    end
                end
            end
            @games = games.uniq{|game| game.id}
        end
        
        if @games.length < @num_picks
            @num_picks = @games.length
        end
    end
    
    def submit_picks
        league = League.find(params[:league_id])
        picks = params[:picks]
        week = Time.now.strftime('%U')
        
        league_pick = LeaguePick.create(:league_id => league.id, :user_id => current_user.id, :week => week)
        picks.each do |game_id, team_name|
            game = Game.find(game_id)
            Pick.create(:game_id => game.id, :league_pick_id => league_pick.id, :home_wins => game.home_team == team_name)
        end
        
        flash[:notice] = "Picks saved successfully!"
        redirect_to league_path(league)
    end
    
    def show_picks
        league = League.find(params[:league_id])
        @user = User.find(params[:user_id])
        week = Time.now.strftime('%U')
        
        my_picks = LeaguePick.where(league_id: league.id, user_id: current_user.id, week: week).take
        
        if my_picks == nil && @user.id == current_user.id
            redirect_to games_picks_path(league)
            return
        elsif my_picks == nil
            render "games/make_my_picks_first"
            return
        end
        
        @league_pick = LeaguePick.where(league_id: league.id, user_id: @user.id, week: week).take
        
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