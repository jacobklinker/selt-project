class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]

  def index
    @leagues = League.all
  end
  
  def new
    @league = League.new
  end

  def show
    if @league == nil then
      flash[:notice] = "Oops, that league doesn't exist!"
      redirect_to leagues_path
      return
    end
    
    week = Time.now.strftime('%U')
        
    @tiebreaker = Tiebreaker.where(league_id: @league.id,  week: week).take
    
    #@tiebreaker_game = Game.where(id: tiebreaker.game_id).take
    
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
    
    #winnersIds = [];
    #winnersIds << 2;
    
    @season_weekly_winners = []
    year = Time.now.strftime('%Y').to_i
    i = 1;
    weekly_winners=WeeklyWinner.where(league_id: @league.id, year: year )
    weekly_winners.each do |week_winner|
      (week_winner.winners.size).times do |winner_index|
        user = User.find(week_winner.winners[winner_index]);
        @season_weekly_winners << {
          :week_number => i,
          :name => user.first_name + " " + user.last_name,
          :wins => (LeaguePick.where(user_id: user.id, league_id: @league.id, week: week_winner.week)[0]).wins,
          :losses => (LeaguePick.where(user_id: user.id, league_id: @league.id, week: week_winner.week)[0]).losses,
          :pushes => (LeaguePick.where(user_id: user.id, league_id: @league.id, week: week_winner.week)[0]).pushes
        }
      end
      i = i + 1;
    end
    
    @standings = Hash.new
    i = 1;
    
    @updated_standings=[]
    if @season_weekly_winners == []
      @updated_standings = @players
    else
      all_year_league_picks=LeaguePick.where(league_id: @league.id)
      all_year_league_picks.each do |league_pick|
        if(!(@standings.has_key?(league_pick.user_id)))
          @standings[league_pick.user_id]={:wins => league_pick.wins, :losses => league_pick.losses, :pushes => league_pick.pushes}
        else
          temp=@standings
          if temp[league_pick.user_id][:wins] != nil
            @standings[league_pick.user_id]={:wins => (temp[league_pick.user_id][:wins] + league_pick.wins), :losses => (temp[league_pick.user_id][:losses] + league_pick.losses), :pushes => (temp[league_pick.user_id][:pushes] + league_pick.pushes)} 
          end
        end
      end
      @standings=@standings.sort_by{|k,v| [v[:wins], v[:pushes]]}.reverse!
  
      lastwins=0
      lastlosses=0
      lastpushes=0
      lastrank=0
      @standings.each do |entry|
        user = User.find(entry[0]);
        if(lastwins==entry[1][:wins] && lastlosses==entry[1][:losses] && entry[1][:pushes])
          rank=lastrank
        else
          rank=i
        end
        i=i+1
        @updated_standings << {
          :rank => rank,
          :name => user.first_name + " " + user.last_name,
          :wins => entry[1][:wins],
          :losses =>entry[1][:losses],
          :pushes =>entry[1][:pushes],
          :id => user.id
        }
        
        lastrank=rank
        
        lastwins=entry[1][:wins]
        lastlosses=entry[1][:losses]
        lastpushes=entry[1][:pushes]
      end
      
    end
      #weekly_winners.each do |week_winner|
     # (week_winner.winners.size).times do |winner_index|
      #  user = User.find(week_winner.winners[winner_index]);
       # @season_weekly_winners << {
        #  :week_number => i,
         # :name => user.first_name + " " + user.last_name,
          #:wins => (LeaguePick.where(user_id: user.id, week: week_winner.week)[0]).wins,
          #:losses => (LeaguePick.where(user_id: user.id, week: week_winner.week)[0]).losses,
        #  :pushes => (LeaguePick.where(user_id: user.id, week: week_winner.week)[0]).pushes
        #}
      #end
      #i = i + 1;
    #end
    
    week = Time.now.strftime('%U')
    @league_pick = LeaguePick.where(user_id: current_user.id, league_id: @league.id, week: week).take
    
    @show_announcements = false
    @show_announcements = true unless @league.commissioner_id != current_user.id
    
  end

  def edit
    if @league == nil then
      flash[:notice] = "Oops, that league doesn't exist!"
      redirect_to leagues_path
      return
    end
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
      user = User.find(user_id);
      @players << {
        :id => user.id,
        :rank => i,
        :name => user.first_name + " " + user.last_name,
        :points => "NA"
      }
      i = i + 1;
    end
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
        
        if @this_user.league1_id == nil
          @this_user.league1_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.league2_id == nil
          @this_user.league2_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.league3_id == nil
          @this_user.league3_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.league4_id == nil
          @this_user.league4_id = @league.id
          @this_user.num_leagues=@this_user.num_leagues+1
        elsif @this_user.league5_id == nil
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
      user = User.find(user_id);
      @players << {
        :id => user.id,
        :rank => i,
        :name => user.first_name + " " + user.last_name,
        :points => "NA"
      }
      i = i + 1;
    end
    respond_to do |format|
      if @league.update(league_params)
        array_of_emails = params[:email_list].split(',')
        array_of_emails.each {|x| UserMailer.league_invite(x,@league.id).deliver_now}  #SEND EMAIL HERE
        if params[:new_commissioner] != nil
          new_commissioner_id= params[:new_commissioner]
          @league.commissioner_id=new_commissioner_id
          @league.save!
        end
        if params[:player_to_delete_ids] != nil
          params[:player_to_delete_ids].each do |player|
            user=User.find(player)
            if ((@league.commissioner_id.to_s != player.to_s) ||( @league.number_members ==1))
              user = User.find(player)
              if @league.user1_id.to_s == player.to_s
                @league.user1_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
                
              elsif @league.user2_id.to_s == player.to_s
                @league.user2_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
  
              elsif @league.user3_id.to_s == player.to_s
                @league.user3_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
               user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user4_id.to_s == player.to_s
                @league.user4_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user5_id.to_s == player.to_s
                @league.user5_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user6_id.to_s == player.to_s
                @league.user6_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user7_id.to_s == player.to_s
                @league.user7_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user8_id.to_s == player.to_s
                @league.user8_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user9_id.to_s == player.to_s
                @league.user9_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user10_id.to_s == player.to_s
                @league.user10_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user11_id.to_s == player.to_s
                @league.user11_id = nil
                @league.number_members = (@league.number_members-1)
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user12_id.to_s == player.to_s
                @league.user12_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user13_id.to_s == player.to_s
                @league.user13_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user14_id.to_s == player.to_s
                @league.user14_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user15_id.to_s == player.to_s
                @league.user15_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user16_id.to_s == player.to_s
                @league.user16_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user17_id.to_s == player.to_s
                @league.user17_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user18_id.to_s == player.to_s
                @league.user18_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user19_id.to_s == player.to_s
                @league.user19_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                #user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              elsif @league.user20_id.to_s == player.to_s
                @league.user20_id = nil
                @league.number_members = (@league.number_members-1)
                @league.save!
                ##user = User.find(player)
                user.num_leagues = ((user.num_leagues) -1)
              end
              if user.league1_id.to_s == @league.id.to_s
                user.league1_id=nil
              elsif user.league2_id.to_s == @league.id.to_s
                user.league2_id=nil
              elsif user.league3_id.to_s == @league.id.to_s
                user.league3_id=nil
              elsif user.league4_id.to_s == @league.id.to_s
                user.league4_id=nil
              elsif user.league5_id.to_s == @league.id.to_s
                user.league5_id=nil
              end
            else 
              flash[:notice]="You are the commisioner and cannot be deleted"
            end
            user.save!
          end
        end
        format.html { redirect_to league_path(@league), notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
    @league.save! 
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
      if @league.user1_id==nil
        @league.user1_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user2_id==nil
        @league.user2_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user3_id==nil
        @league.user3_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user4_id==nil
        @league.user4_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user5_id==nil
        @league.user5_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user6_id==nil
        @league.user6_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user7_id==nil
        @league.user7_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user8_id==nil
        @league.user8_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user9_id==nil
        @league.user9_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user10_id==nil
        @league.user10_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user11_id==nil
        @league.user11_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user12_id==nil
        @league.user12_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user13_id==nil
        @league.user13_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user14_id==nil
        @league.user14_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user15_id==nil
        @league.user15_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user16_id==nil
        @league.user16_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user17_id==nil
        @league.user17_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user18_id==nil
        @league.user18_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user19_id==nil
        @league.user19_id = current_user.id
        @league.number_members= num_members+1
      elsif @league.user20_id==nil
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
    # use find by id instead of find since that will return nil if the record doesn't exist.
    # find just throws an exception.
    
    @league = League.find_by_id(params[:league_id])
    
    if @league == nil then
      flash[:notice] = "Oops, that league doesn't exist!"
      redirect_to authenticated_root_path
      return
    end
  end
  
  def create_announcement
    if (League.find_by_id(params[:league_id]) == nil) then
      flash[:notice] = "Oops, that league doesn't exist!"
      redirect_to authenticated_root_path
      
      return
    end 
    
    if (params[:text] == nil || params[:text][:announcement] == "" || params[:text][:start_time] == "" || params[:text][:end_time] == "") then
      flash[:notice] = "Please complete the form!"
      redirect_to leagues_add_announcements_path(params[:league_id])
      
      return
    end 
    
    announcement = Announcement.new
    announcement.league_id = params[:league_id]
    announcement.announcement = params[:text][:announcement]
    announcement.start_date = params[:text][:start_time]
    announcement.end_date = params[:text][:end_time]
    
    announcement.save
    
    flash[:notice] = "Added an announcement to your league!"
    redirect_to authenticated_root_path
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
