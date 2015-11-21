require 'rails_helper'

describe LeaguesController do
  
  before :each do
    allow_message_expectations_on_nil
    allow(controller.current_user).to receive(:id).and_return(1)
  end

  it "index should load all the leagues" do
      expect(League).to receive(:all)
      post :index
  end
  
  describe "viewing a valid league" do 
    before :each do
      @league = League.new
      @league.commissioner_id = 1
      
      @commissioner = User.create
      @commissioner.email = "test@test.com"
      @commissioner.first_name = "test"
      @commissioner.last_name = "user"
    end
    
    describe "with zero participants" do 
      before :each do
        expect(League).to receive(:find).with("1").and_return(@league)
        expect(User).to receive(:find).with(1).and_return(@commissioner)
        expect(User).to receive(:find).with(2).and_return(@commissioner)
        
        get :show, {:id => 1}
      end
    
      it "should assign league to the league value" do
        expect(assigns(:league)).to be @league
      end
      
      it "should have an empty players array" do
        expect(assigns(:players)).to eq []
      end
    end
    
    describe "with participants" do
       before :each do
        @league.user1_id = 1
        
        expect(League).to receive(:find).with("1").and_return(@league)
        expect(User).to receive(:find).with(1).at_least(:once).and_return(@commissioner)
        expect(User).to receive(:find).with(2).and_return(@commissioner)
        
        get :show, {:id => 1}
      end
    
      it "should assign league to the league value" do
        expect(assigns(:league)).to be @league
      end
      
      it "should not have an empty players array" do
        expect(assigns(:players)).not_to eq []
      end
    end
  end
    
  describe "viewing an invalid league" do 
    it "should assign league to the league value" do
      expect(League).to receive(:find).with("1").and_return(nil)
      get :show, {:id => 1}
      
      expect(flash[:notice]).to eq("Oops, that league doesn't exist!")
      expect(response).to redirect_to(leagues_path)
    end
  end
  
  describe "creating a new league" do
    it "should return a new league object" do
      league = double(League)
      expect(League).to receive(:new).and_return(league)
      
      get :new
      
      expect(assigns(:league)).to eq(league)
    end
    
    describe "Create a league" do
      describe "when a user alreay has 5 leagues" do
        it "will not create the league notifies the user" do
          @user=double(User)
          allow(User).to receive(:find).and_return(@user)
          allow(@user).to receive(:num_leagues).and_return(5)
          allow(controller.current_user).to receive(:id).and_return(1)
          post :create, :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}
          expect(flash[:notice]).to eq("League not created because you have reached max number of leagues!!")
          expect(response).to redirect_to(authenticated_root_path)
        end
      end
      describe "when user is allowed to make a new league" do
        it "will make the new league and store as 1st league" do
          @user=double(User)
          @league=double(League)
          allow(User).to receive(:find).and_return(@user)
          allow(@user).to receive(:num_leagues).and_return(0)
          expect(@user).to receive(:league1_id).to eq(1)
          #allow(@league).to receive(:id).and_return(1)
          #expect(@user).to receive(:save)
          #allow(@user).to receive(:num_leagues).and_return(1)
          
          #allow(@user).to receive(:num_leagues).and_return(2)
          #allow(@user).to receive(:num_leagues).and_return(4)
          #allow(controller.current_user).to receive(:id).and_return(1)
          #expect(response).to redirect_to(authenticated_root_path)
          post :create, :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}
         #expect(assigns(@user.num_leagues)).to eq(@user.num_leagues+1)
        end
      end
    end
  end
end