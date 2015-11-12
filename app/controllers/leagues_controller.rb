class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]

  # GET /leagues
  # GET /leagues.json
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  # POST /leagues.json
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
        else
          flash[:notice]="Not added to this League. Max number of leagues reached"
        end

        @this_user.save!
        
        
        format.html { redirect_to @league }
        format.json { render :show, status: :created, location: @league }
        array_of_emails = params[:email_list].split
        array_of_emails.each {|x| UserMailer.league_invite(x,@league.id).deliver_now}  #SEND EMAIL HERE
      else
        format.html { render :new }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
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