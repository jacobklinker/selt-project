require 'rails_helper'

describe LeaguesController do

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
  describe "adding a user to the league" do
    it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(6)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
    it "move to the second if statement" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(5)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(2)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(2)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
    it "move to the second if statement" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(4)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(3)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(3)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "move to the second if statement" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(3)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(4)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(4)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "move to the second if statement" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(1)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(5)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(5)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "move to the second if statement" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(2)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(7)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(8)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(9)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(10)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(11)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(12)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(13)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(14)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(15)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(16)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(17)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(18)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(19)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "should receive the league id to add the user to" do 
      allow_message_expectations_on_nil()
            
      user = double(User.new(:num_leagues => 0))
      league = League.new()
      allow(league).to receive(:number_members).and_return(19)
      allow(League).to receive(:find).and_return(league)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(user).to receive(:num_leagues).and_return(0)
      allow(user).to receive(:league1_id=).and_return(1)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
   it "move to the second if statement" do 
      allow_message_expectations_on_nil()
      allow(controller.current_user).to receive(:id).and_return(4)     
      user = double(User.new(:id =>4, :num_leagues => 0))
      league = double(league)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(2)
      allow(league).to receive(:user2_id).and_return(3)
      allow(league).to receive(:user3_id).and_return(4)
      allow(league).to receive(:user4_id).and_return(5)
      allow(league).to receive(:user5_id).and_return(6)
      allow(league).to receive(:user6_id).and_return(7)
      allow(league).to receive(:user7_id).and_return(8)
      allow(league).to receive(:user8_id).and_return(9)
      allow(league).to receive(:user9_id).and_return(10)
      allow(league).to receive(:user10_id).and_return(11)
      allow(league).to receive(:user11_id).and_return(12)
      allow(league).to receive(:user12_id).and_return(13)
      allow(league).to receive(:user13_id).and_return(14)
      allow(league).to receive(:user14_id).and_return(15)
      allow(league).to receive(:user15_id).and_return(16)
      allow(league).to receive(:user16_id).and_return(17)
      allow(league).to receive(:user17_id).and_return(18)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(1)
      allow(User).to receive(:find).with(1).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      post :add_user_to_league, {:league_id => 1}
   end
  end
end

