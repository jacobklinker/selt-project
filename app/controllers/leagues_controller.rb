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
    @league.commissioner_id=current_user.id
    
    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully created.' }
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
    
  end
  
  def add_user_to_league
    
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
