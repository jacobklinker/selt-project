class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]

  def index
    @leagues = League.all
  end

  def show
    if @league == nil then
      flash[:notice] = "Oops, that league doesn't exist!"
      redirect_to leagues_path
      return
    end
    
    week = Time.now.strftime('%U')
        
    tiebreaker = Tiebreaker.where(league_id: @league.id,  week: week).take
    
    @tiebreaker_game = Game.where(id: tiebreaker.game_id).take
    
    @infos = [];
    @infos << { :title => "Commissioner", :data => User.find(@league.commissioner_id).email };
    @infos << { :title => "Conference", :data => @league.conference_settings };
    @infos << { :title => "Picks Per Week", :data => @league.number_picks_settings };
    
    # list of members
    memberIds = [];
    memberIds << @league.user1_id unless @league.user1_id == nil
    memberIds << @league.user2_id unless @league.user2_id == nil
    memberIds << @league.user3_id unless @league.user3_id == nil
    memberIds << @league.user4_id unless @league.user4_id == nil
    memberIds << @league.user5_id unless @league.user5_id == nil
    memberIds << @league.user6_id unless @league.user6_id == nil
    memberIds << @league.user7_id unless @league.user7_id == nil
    memberIds << @league.user8_id unless @league.user8_id == nil
    memberIds << @league.user9_id unless @league.user9_id == nil
    memberIds << @league.user10_id unless @league.user10_id == nil
    memberIds << @league.user11_id unless @league.user11_id == nil
    memberIds << @league.user12_id unless @league.user12_id == nil
    memberIds << @league.user13_id unless @league.user13_id == nil
    memberIds << @league.user14_id unless @league.user14_id == nil
    memberIds << @league.user15_id unless @league.user15_id == nil
    memberIds << @league.user16_id unless @league.user16_id == nil
    memberIds << @league.user17_id unless @league.user17_id == nil
    memberIds << @league.user18_id unless @league.user18_id == nil
    memberIds << @league.user19_id unless @league.user19_id == nil
    memberIds << @league.user20_id unless @league.user20_id == nil
        
    @players = [];
    i = 1;
    memberIds.each do |user_id|
      user = User.find(user_id)
      @players << {
        :id => user.id,
        :rank => i,
        :name => user.first_name + " " + user.last_name,
        :points => "NA"
      }
      i = i + 1;
    end
    
    winnersIds = [];
    winnersIds << 2;
    
    @weekly_winners = []
    i = 1;
    winnersIds.each do |user_id|
      user = User.find(user_id);
      @weekly_winners << {
        :week_number => i,
        :name => user.first_name + " " + user.last_name,
        :points => "6"
      }
      i = i + 1;
    end
    
    week = Time.now.strftime('%U')
    @league_pick = LeaguePick.where(user_id: current_user.id, league_id: @league.id, week: week).find_each
    
  end

  def new
    @league = League.new
  end

  def edit
  end

  def create
    @league = League.new(league_params)
    @this_user=User.find(current_user.id)
    @league.commissioner_id=current_user.id
    @league.user1_id=current_user.id
    @league.number_members = 1
    
    if @this_user.num_leagues >= 5
      flash[:notice]="League not created because you have reached max number of leagues!!"
      redirect_to authenticated_root_path
      return
    end
    
    respond_to do |format|
      if @league.save
        
        if @this_user.num_leagues==0
          @this_user.league1_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.num_leagues==1
          @this_user.league2_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.num_leagues==2
          @this_user.league3_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.num_leagues==3
          @this_user.league4_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.num_leagues==4
          @this_user.league5_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        end

        @this_user.save!
        
        
        format.html { redirect_to @league }
        format.json { render :show, status: :created, location: @league }
        array_of_emails = params[:email_list].split(',')
        array_of_emails.each {|x| UserMailer.league_invite(x,@league.id).deliver_now}  #SEND EMAIL HERE
      else
        format.html { render :new }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @league.update(league_params)
        array_of_emails = params[:email_list].split(',')
        array_of_emails.each {|x| UserMailer.league_invite(x,@league.id).deliver_now}  #SEND EMAIL HERE
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @league.destroy
    respond_to do |format|
      format.html { redirect_to leagues_url, notice: 'League was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def accept_invite
    #@league = League.find(params[:param1])
  end
  
  def add_user_to_league
    @league = League.find(params[:league_id])
    num_members=@league.number_members

    enter_user = true
    
    
    if @league.user1_id == current_user.id
      enter_user =false
    elsif @league.user2_id == current_user.id
      enter_user = false
     elsif @league.user3_id == current_user.id
      enter_user = false
    elsif @league.user4_id == current_user.id
      enter_user = false
    elsif @league.user5_id == current_user.id
      enter_user = false
    elsif @league.user6_id == current_user.id
      enter_user = false
    elsif @league.user7_id == current_user.id
      enter_user = false
    elsif @league.user8_id == current_user.id
      enter_user = false
    elsif @league.user9_id == current_user.id
      enter_user = false
    elsif @league.user10_id == current_user.id
      enter_user = false
    elsif @league.user11_id == current_user.id
      enter_user = false
    elsif @league.user12_id == current_user.id
      enter_user = false
    elsif @league.user13_id == current_user.id
      enter_user = false
    elsif @league.user14_id == current_user.id
      enter_user = false
    elsif @league.user15_id == current_user.id
      enter_user = false
    elsif @league.user16_id == current_user.id
      enter_user = false
    elsif @league.user17_id == current_user.id
      enter_user = false
    elsif @league.user18_id == current_user.id
      enter_user = false
    elsif @league.user19_id == current_user.id
      enter_user = false
    elsif @league.user20_id == current_user.id
      enter_user = false
    end
   
    if enter_user ==true 
      if num_members==0
        @league.user1_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 1
        @league.user2_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 2
        @league.user3_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 3
        @league.user4_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 4
        @league.user5_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 5
        @league.user6_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 6
        @league.user7_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 7
        @league.user8_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 8
        @league.user9_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 9
        @league.user10_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 10
        @league.user11_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 11
        @league.user12_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 12
        @league.user13_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 13
        @league.user14_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 14
        @league.user15_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 15
        @league.user16_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 16
        @league.user17_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 17
        @league.user18_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 18
        @league.user19_id = current_user.id
        @league.number_members= num_members+1
      elsif num_members == 19
        @league.user20_id = current_user.id
        @league.number_members= num_members+1
      end
      flash[:notice]="Successfully added to the league"
      
      @this_user=User.find(current_user.id)
      
      if @this_user.num_leagues==0
        @this_user.league1_id = @league.id
        @this_user.num_leagues=@this_user.num_leagues+1
      elsif @this_user.num_leagues==1
        @this_user.league2_id = @league.id
        @this_user.num_leagues=@this_user.num_leagues+1
      elsif @this_user.num_leagues==2
        @this_user.league3_id = @league.id
        @this_user.num_leagues=@this_user.num_leagues+1
      elsif @this_user.num_leagues==3
        @this_user.league4_id = @league.id
        @this_user.num_leagues=@this_user.num_leagues+1
      elsif @this_user.num_leagues==4
        @this_user.league5_id = @league.id
        @this_user.num_leagues=@this_user.num_leagues+1
      else
        flash[:notice]="Not added to this League. Max number of leagues reached"
      end
      @this_user.save!()
      @league.save!()
    else
      flash[:notice]="You are already a member of this league"
    end
    redirect_to authenticated_root_path
  end
  
  def add_announcement
    
  end
  
  def set_tiebreaker
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
    @league_name = League.find(params[:league_id]).league_name
    
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
    
  def submit_tiebreaker
      league = League.find(params[:league_id])
      selected_game = params[:tiebreaker]
      week = Time.now.strftime('%U')
      
      Tiebreaker.create(:league_id => league.id, :game_id => selected_game, :week => week)
      
      #league_pick = LeaguePick.create(:league_id => league.id, :user_id => current_user.id, :week => week)
      #picks.each do |game_id, team_name|
      #    game = Game.find(game_id)
      #    Pick.create(:game_id => game.id, :league_pick_id => league_pick.id, :home_wins => game.home_team == team_name)
      #end
      
      flash[:notice] = "Tiebreaker set successfully!"
      redirect_to league_path(league)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_params
      params.require(:league).permit(:league_name, :commissioner_id, :current_leader_id, :conference_settings, :number_picks_settings, :number_members, :user1_id, :user2_id, :user3_id, :user4_id, :user5_id, :user6_id, :user7_id, :user8_id, :user9_id, :user10_id, :user11_id, :user12_id, :user13_id, :user14_id, :user15_id, :user16_id, :user17_id, :user18_id, :user19_id, :user20_id)
    end
end
