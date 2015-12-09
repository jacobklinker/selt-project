require 'rails_helper'

describe LeaguesController do
  
  before :each do
    allow_message_expectations_on_nil
    allow(controller.current_user).to receive(:id).and_return(1)
  end
  
  it "should show the add announcement page for a valid league" do
      expect(League).to receive(:find_by_id).with("1").and_return(League.new)
      get :add_announcement, {:league_id => 1}
  end
  
  it "should redirect to the home page for an invalid league" do 
      expect(League).to receive(:find_by_id).with("1").and_return(nil)

      get :add_announcement, {:league_id => 1}
      
      expect(flash[:notice]).to eq("Oops, that league doesn't exist!")
      expect(response).to redirect_to(authenticated_root_path)
  end
  
  describe "show the announcement button" do 
      before :each do 
          @league = League.new
          
          @commissioner = User.create
          @commissioner.email = "test@test.com"
          @commissioner.first_name = "test"
          @commissioner.last_name = "user"
      end
      
      it "should display the add announcement button if the user is an admin" do
          @league.commissioner_id = 1
          
          expect(User).to receive(:find).with(1).and_return(@commissioner)
          expect(User).to receive(:find).with(2).and_return(@commissioner)
          expect(League).to receive(:find).with("1").and_return(@league)
          
          get :show, {:id => 1}
          
          expect(assigns(:show_announcements)).to eq true
      end
  
      it "should not display the add announcement button if the user is an admin" do
          @league.commissioner_id = 2
          
          expect(User).to receive(:find).with(2).and_return(@commissioner).twice
          expect(League).to receive(:find).with("1").and_return(@league)
          
          get :show, {:id => 1}
          
          expect(assigns(:show_announcements)).to eq false
      end
  end
  
  describe "saving announcements" do 
      it "should save the announcement if all fields are filled" do
          expect(League).to receive(:find_by_id).with("1").and_return(League.new)
          
          post :create_announcement, { :league_id => 1, :text => { :announcement => "test", :start_time => "2015-12-04", :end_time => "2015-12-05" } }
                
          expect(flash[:notice]).to eq("Added an announcement to your league!")
          expect(response).to redirect_to(authenticated_root_path)
      end
      
      it "should redirect to home if the league id is invalid" do
          expect(League).to receive(:find_by_id).with("1").and_return(nil)
          
          post :create_announcement, { :league_id => 1 }
                
          expect(flash[:notice]).to eq("Oops, that league doesn't exist!")
          expect(response).to redirect_to(authenticated_root_path)
      end 
      
      it "should redirect to league page if the league id is valid but all other params are invalid" do
          expect(League).to receive(:find_by_id).with("1").and_return(League.new)

          post :create_announcement, { :league_id => 1 }
                
          expect(flash[:notice]).to eq("Please complete the form!")
          expect(response).to redirect_to(leagues_add_announcements_path("1"))
      end 
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
    
    describe "creating a league" do 
      before :each do
        @league_params={:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}
      end
      describe "with a user who has 5 existing leagues" do
        it "should tell user 'League not created because you have reached max number of leagues!!'" do
          get :new
          #league=double(League.create(@league_params))
  
          expect(League).to receive(:new)
        
          #expect(flash[:notice]).to eq("Oops, that league doesn't exist!")
          #expect(response).to redirect_to(leagues_path)
        end
      end
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
    it "move to the 5th if statement of adding league" do 
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
    it "move to the 4th if statement of adding league" do 
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
   it "" do 
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
   it "move to the 1st if statement of adding league" do 
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
      expect(flash[:notice]).to eq("Not added to this League. Max number of leagues reached")
   end
   it "move to the 2nd if statement of adding league" do 
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
      expect(flash[:notice]).to eq("Successfully added to the league")
      
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
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
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
   it "move to the 1st if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(2)  
      
      league = double(League)

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
      allow(controller.current_user).to receive(:id).and_return(2)
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
      expect(flash[:notice]).to eq("You are already a member of this league")
   end
    it "move to the 2nd if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(3)  
      
      league = double(League)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(1)
      allow(league).to receive(:user2_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(3)
      allow(User).to receive(:find).with(3).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user2_id=).and_return(3)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 3rd if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(4)  
      
      league = double(League)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(2)
      allow(league).to receive(:user2_id).and_return(3)
      allow(league).to receive(:user3_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(4)
      allow(User).to receive(:find).with(4).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user3_id=).and_return(4)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 4th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(5)  
      
      league = double(League)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(2)
      allow(league).to receive(:user2_id).and_return(3)
      allow(league).to receive(:user3_id).and_return(4)
      allow(league).to receive(:user4_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(5)
      allow(User).to receive(:find).with(5).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user4_id=).and_return(5)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 5th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(6)  
      
      league = double(League)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(2)
      allow(league).to receive(:user2_id).and_return(3)
      allow(league).to receive(:user3_id).and_return(4)
      allow(league).to receive(:user4_id).and_return(5)
      allow(league).to receive(:user5_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(6)
      allow(User).to receive(:find).with(6).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user5_id=).and_return(6)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 6th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(7)  
      
      league = double(League)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(2)
      allow(league).to receive(:user2_id).and_return(3)
      allow(league).to receive(:user3_id).and_return(4)
      allow(league).to receive(:user4_id).and_return(5)
      allow(league).to receive(:user5_id).and_return(6)
      allow(league).to receive(:user6_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(7)
      allow(User).to receive(:find).with(7).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user6_id=).and_return(7)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 7th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(8)  
      
      league = double(League)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(2)
      allow(league).to receive(:user2_id).and_return(3)
      allow(league).to receive(:user3_id).and_return(4)
      allow(league).to receive(:user4_id).and_return(5)
      allow(league).to receive(:user5_id).and_return(6)
      allow(league).to receive(:user6_id).and_return(7)
      allow(league).to receive(:user7_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(8)
      allow(User).to receive(:find).with(8).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user7_id=).and_return(8)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 8th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(9)  
      
      league = double(League)

      allow(League).to receive(:find).and_return(league)
      allow(league).to receive(:number_members).and_return(0)
      allow(league).to receive(:user1_id).and_return(2)
      allow(league).to receive(:user2_id).and_return(3)
      allow(league).to receive(:user3_id).and_return(4)
      allow(league).to receive(:user4_id).and_return(5)
      allow(league).to receive(:user5_id).and_return(6)
      allow(league).to receive(:user6_id).and_return(7)
      allow(league).to receive(:user7_id).and_return(8)
      allow(league).to receive(:user8_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(9)
      allow(User).to receive(:find).with(9).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user8_id=).and_return(9)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 9th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(10)  
      
      league = double(League)

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
      allow(league).to receive(:user9_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(10)
      allow(User).to receive(:find).with(10).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user9_id=).and_return(10)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 10th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(11)  
      
      league = double(League)

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
      allow(league).to receive(:user10_id).and_return(nil)
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
      allow(controller.current_user).to receive(:id).and_return(11)
      allow(User).to receive(:find).with(11).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user10_id=).and_return(11)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 11th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(12)  
      
      league = double(League)

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
      allow(league).to receive(:user11_id).and_return(nil)
      allow(league).to receive(:user12_id).and_return(13)
      allow(league).to receive(:user13_id).and_return(14)
      allow(league).to receive(:user14_id).and_return(15)
      allow(league).to receive(:user15_id).and_return(16)
      allow(league).to receive(:user16_id).and_return(17)
      allow(league).to receive(:user17_id).and_return(18)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(12)
      allow(User).to receive(:find).with(12).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user11_id=).and_return(12)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 12th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(13)  
      
      league = double(League)

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
      allow(league).to receive(:user12_id).and_return(nil)
      allow(league).to receive(:user13_id).and_return(14)
      allow(league).to receive(:user14_id).and_return(15)
      allow(league).to receive(:user15_id).and_return(16)
      allow(league).to receive(:user16_id).and_return(17)
      allow(league).to receive(:user17_id).and_return(18)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(13)
      allow(User).to receive(:find).with(13).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user12_id=).and_return(13)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 13th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(14)  
      
      league = double(League)

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
      allow(league).to receive(:user13_id).and_return(nil)
      allow(league).to receive(:user14_id).and_return(15)
      allow(league).to receive(:user15_id).and_return(16)
      allow(league).to receive(:user16_id).and_return(17)
      allow(league).to receive(:user17_id).and_return(18)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(14)
      allow(User).to receive(:find).with(14).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user13_id=).and_return(14)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 14th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(15)  
      
      league = double(League)

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
      allow(league).to receive(:user14_id).and_return(nil)
      allow(league).to receive(:user15_id).and_return(16)
      allow(league).to receive(:user16_id).and_return(17)
      allow(league).to receive(:user17_id).and_return(18)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(15)
      allow(User).to receive(:find).with(15).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user14_id=).and_return(15)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 15th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(16)  
      
      league = double(League)

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
      allow(league).to receive(:user15_id).and_return(nil)
      allow(league).to receive(:user16_id).and_return(17)
      allow(league).to receive(:user17_id).and_return(18)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(16)
      allow(User).to receive(:find).with(16).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user15_id=).and_return(16)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 16th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(17)  
      
      league = double(League)

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
      allow(league).to receive(:user16_id).and_return(nil)
      allow(league).to receive(:user17_id).and_return(18)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(17)
      allow(User).to receive(:find).with(17).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user16_id=).and_return(17)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 17th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(18)  
      
      league = double(League)

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
      allow(league).to receive(:user17_id).and_return(nil)
      allow(league).to receive(:user18_id).and_return(19)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(18)
      allow(User).to receive(:find).with(18).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user17_id=).and_return(18)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 18th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(19)  
      
      league = double(League)

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
      allow(league).to receive(:user18_id).and_return(nil)
      allow(league).to receive(:user19_id).and_return(20)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(19)
      allow(User).to receive(:find).with(19).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user18_id=).and_return(19)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 19th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(20)  
      
      league = double(League)

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
      allow(league).to receive(:user19_id).and_return(nil)
      allow(league).to receive(:user20_id).and_return(21)
      allow(controller.current_user).to receive(:id).and_return(20)
      allow(User).to receive(:find).with(20).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user19_id=).and_return(20)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
    it "move to the 20th if statement of checking if user is in the league" do 
      allow_message_expectations_on_nil()
         
      user = double(User.new(:id =>4, :num_leagues => 0))
      expect(controller.current_user).to receive(:id).and_return(21)  
      
      league = double(League)

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
      allow(league).to receive(:user20_id).and_return(nil)
      allow(controller.current_user).to receive(:id).and_return(21)
      allow(User).to receive(:find).with(21).and_return(user)
      allow(league).to receive(:user1_id=).and_return(2)
      allow(league).to receive(:number_members=).and_return(2)
      allow(league).to receive(:id).and_return(1)
      allow(user).to receive(:num_leagues).and_return(1)
      allow(user).to receive(:league1_id=).and_return(2)
      allow(user).to receive(:num_leagues=).and_return(1)
      allow(user).to receive(:save!)
      allow(league).to receive(:save!)
      allow(league).to receive(:user20_id=).and_return(21)
      allow(user).to receive(:league2_id=).and_return(3)
      allow(user).to receive(:league3_id=).and_return(4)
      allow(user).to receive(:league4_id=).and_return(5)
      allow(user).to receive(:league5_id=).and_return(6)
      
     # expect(League).to receive(:find).with("1").and_return(league)
      #allow(league).to receive(:id).and_return(1)
      #league.user1_id=1
      #current_user.id=10
      
      post :add_user_to_league, {:league_id => 1}
      expect(flash[:notice]).to eq("Successfully added to the league")
   end
  end
  describe "testing update" do
   it 'should update the page' do
     expect(League).to receive(:update)
     league = double(League)
     League.update
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
        #These test are temporarily failing due sending email line of create (EXPECTED TO FAIL)
        it "will make the new league and store as 1st league" do
          @user=double(User)
          allow(User).to receive(:find).and_return(@user)
          allow(controller.current_user).to receive(:id).and_return(1)
          allow(@user).to receive(:num_leagues).and_return(0)
          allow(@user).to receive(:league1_id).and_return(nil)
          allow(@user).to receive(:league1_id=).and_return(1)
          allow(@user).to receive(:num_leagues=).and_return(1)
          expect(@user).to receive(:save!)
         
          post :create, {:email_list=>"", :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}}
        end
        it "will make the new league and store as 2nd league" do
          @user=double(User)
          @league=double(League)
          @email_array="tyler-parker@uiowa.edu, tyson-massey@uiowa.edu"
          allow(User).to receive(:find).and_return(@user)
          allow(controller.current_user).to receive(:id).and_return(1)
          allow(@user).to receive(:num_leagues).and_return(1)
          allow(@user).to receive(:league1_id).and_return(5)
          allow(@user).to receive(:league2_id).and_return(nil)
          allow(@user).to receive(:league2_id=).and_return(1)
          allow(@user).to receive(:num_leagues=).and_return(2)
          expect(@user).to receive(:save!)
          post :create, {:email_list=>"", :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}}
        end
        it "will make the new league and store as 3rd league" do
          @user=double(User)
          @league=double(League)
          @email_array="tyler-parker@uiowa.edu, tyson-massey@uiowa.edu"
          allow(User).to receive(:find).and_return(@user)
          allow(controller.current_user).to receive(:id).and_return(1)
          allow(@user).to receive(:num_leagues).and_return(2)
          allow(@user).to receive(:league1_id).and_return(5)
          allow(@user).to receive(:league2_id).and_return(6)
          allow(@user).to receive(:league3_id).and_return(nil)
          allow(@user).to receive(:league3_id=).and_return(1)
          allow(@user).to receive(:num_leagues=).and_return(3)
          expect(@user).to receive(:save!)
          post :create, {:email_list=>"", :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}}
        end
        it "will make the new league and store as 4th league" do
          @user=double(User)
          @league=double(League)
          @email_array="tyler-parker@uiowa.edu, tyson-massey@uiowa.edu"
          allow(User).to receive(:find).and_return(@user)
          allow(controller.current_user).to receive(:id).and_return(1)
          allow(@user).to receive(:num_leagues).and_return(3)
          allow(@user).to receive(:league1_id).and_return(5)
          allow(@user).to receive(:league2_id).and_return(6)
          allow(@user).to receive(:league3_id).and_return(7)
          allow(@user).to receive(:league4_id).and_return(nil)
          allow(@user).to receive(:league4_id=).and_return(1)
          allow(@user).to receive(:num_leagues=).and_return(4)
          expect(@user).to receive(:save!)
          post :create, {:email_list=>"", :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}}
        end
        it "will make the new league and store as 5th league" do
          @user=double(User)
          @league=double(League)
          @email_array="tyler-parker@uiowa.edu, tyson-massey@uiowa.edu"
          allow(User).to receive(:find).and_return(@user)
          allow(controller.current_user).to receive(:id).and_return(1)
          allow(@user).to receive(:num_leagues).and_return(4)
          allow(@user).to receive(:league1_id).and_return(5)
          allow(@user).to receive(:league2_id).and_return(6)
          allow(@user).to receive(:league3_id).and_return(7)
          allow(@user).to receive(:league4_id).and_return(8)
          allow(@user).to receive(:league5_id).and_return(nil)
          allow(@user).to receive(:league5_id=).and_return(1)
          allow(@user).to receive(:num_leagues=).and_return(5)
          expect(@user).to receive(:save!)
          post :create, {:email_list=>"", :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}}
        end
      end
    end
    describe "testing update (delete the members)" do
        before :each do
           @user = double(User)
            @league = double(League)
            @obj = double(Object)
            allow(League).to receive(:update)
            allow(@league).to receive(:update).and_return(true)
            
            allow(User).to receive(:find).and_return(@user)

            allow(@user).to receive(:email).and_return("a@b.com")
            allow(@user).to receive(:id).and_return(3)
            allow(@user).to receive(:first_name).and_return("tyson")
            allow(@user).to receive(:last_name).and_return("massey")

            
            allow(League).to receive(:find).and_return(@league)
            #allow(@league).to receive(:update)
            allow(@league).to receive(:conference_settings).and_return("FBS")
            allow(@league).to receive(:number_picks_settings).and_return(1)
            allow(@league).to receive(:id).and_return(1)
            allow(@league).to receive(:user1_id).and_return(1)
            allow(@league).to receive(:user2_id).and_return(2)
            allow(@league).to receive(:user3_id).and_return(3)
            allow(@league).to receive(:user4_id).and_return(4)
            allow(@league).to receive(:user5_id).and_return(5)
            allow(@league).to receive(:user6_id).and_return(6)
            allow(@league).to receive(:user7_id).and_return(7)
            allow(@league).to receive(:user8_id).and_return(8)
            allow(@league).to receive(:user9_id).and_return(9)
            allow(@league).to receive(:user10_id).and_return(10)
            allow(@league).to receive(:user11_id).and_return(11)
            allow(@league).to receive(:user12_id).and_return(12)
            allow(@league).to receive(:user13_id).and_return(13)
            allow(@league).to receive(:user14_id).and_return(14)
            allow(@league).to receive(:user15_id).and_return(15)
            allow(@league).to receive(:user16_id).and_return(16)
            allow(@league).to receive(:user17_id).and_return(17)
            allow(@league).to receive(:user18_id).and_return(18)
            allow(@league).to receive(:user19_id).and_return(19)
            allow(@league).to receive(:user20_id).and_return(20)
            allow(@league).to receive(:commissioner_id).and_return(5)
            allow(@league).to receive(:number_members).and_return(2)
            allow(@league).to receive(:user1_id=)
            allow(@league).to receive(:user2_id=)
            allow(@league).to receive(:user3_id=)
            allow(@league).to receive(:user4_id=)
            allow(@league).to receive(:user5_id=)
            allow(@league).to receive(:user6_id=)
            allow(@league).to receive(:user7_id=)
            allow(@league).to receive(:user8_id=)
            allow(@league).to receive(:user9_id=)
            allow(@league).to receive(:user10_id=)
            allow(@league).to receive(:user11_id=)
            allow(@league).to receive(:user12_id=)
            allow(@league).to receive(:user13_id=)
            allow(@league).to receive(:user14_id=)
            allow(@league).to receive(:user15_id=)
            allow(@league).to receive(:user16_id=)
            allow(@league).to receive(:user17_id=)
            allow(@league).to receive(:user18_id=)
            allow(@league).to receive(:user19_id=)
            allow(@league).to receive(:user20_id=)
            allow(@league).to receive(:number_members=)
            allow(@user).to receive(:num_leagues=)
            allow(@user).to receive(:num_leagues).and_return(4)
            allow(@league).to receive(:to_model).and_return(@obj)
            allow(@obj).to receive(:persisted?)
            allow(@obj).to receive(:model_name).and_return(@obj)
            allow(@obj).to receive(:route_key).and_return(@obj)
            
            
           
            allow(@user).to receive(:league1_id=).and_return(nil)
            allow(@user).to receive(:league2_id=).and_return(nil)
            allow(@user).to receive(:league3_id=).and_return(nil)
            allow(@user).to receive(:league4_id=).and_return(nil)
            allow(@user).to receive(:league5_id=).and_return(nil)
            allow(@league).to receive(:save!)
            allow(@user).to receive(:save!)
            league_name = "my league" 
        end
        it 'should update the page and go into the first deleted use and delete league 1' do
            allow(@user).to receive(:league1_id).and_return(1)
            allow(@user).to receive(:league2_id).and_return(2)
            allow(@user).to receive(:league3_id).and_return(3)
            allow(@user).to receive(:league4_id).and_return(4)
            allow(@user).to receive(:league5_id).and_return(5)
         
            put :update, {id: @league.id,:league => {:league_name=>"LeagueName", :commissioner_id=>"2", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""},:email_list => "t@m.com",:player_to_delete_ids => [1]}
            expect(flash[:notice]).to eq("League was successfully updated.")
        end
        it 'should update the page and go into the second deleted user and delete league 2' do
            allow(@user).to receive(:league1_id).and_return(2)
            allow(@user).to receive(:league2_id).and_return(1)
            allow(@user).to receive(:league3_id).and_return(3)
            allow(@user).to receive(:league4_id).and_return(4)
            allow(@user).to receive(:league5_id).and_return(5)
         
            put :update, {id: @league.id,:league => {:league_name=>"LeagueName", :commissioner_id=>"2", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""},:email_list => "t@m.com",:player_to_delete_ids => [2]}
            expect(flash[:notice]).to eq("League was successfully updated.")
        end
        it 'should update the page and go into the 3-20 deleted users and delete league 3' do
            allow(@user).to receive(:league1_id).and_return(3)
            allow(@user).to receive(:league2_id).and_return(2)
            allow(@user).to receive(:league3_id).and_return(1)
            allow(@user).to receive(:league4_id).and_return(4)
            allow(@user).to receive(:league5_id).and_return(5)
         
            put :update, {id: @league.id,:league => {:league_name=>"LeagueName", :commissioner_id=>"2", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""},:email_list => "t@m.com",:player_to_delete_ids => [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]}
            expect(flash[:notice]).to eq("League was successfully updated.")
        end
        it 'should update the page and go into the 3-20 deleted users and delete league 4' do
            allow(@user).to receive(:league1_id).and_return(4)
            allow(@user).to receive(:league2_id).and_return(2)
            allow(@user).to receive(:league3_id).and_return(1)
            allow(@user).to receive(:league4_id).and_return(1)
            allow(@user).to receive(:league5_id).and_return(5)
         
            put :update, {id: @league.id,:league => {:league_name=>"LeagueName", :commissioner_id=>"2", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""},:email_list => "t@m.com",:player_to_delete_ids => [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]}
            expect(flash[:notice]).to eq("League was successfully updated.")
        end
        it 'should update the page and go into the 3-20 deleted users and delete league 5' do
            allow(@user).to receive(:league1_id).and_return(5)
            allow(@user).to receive(:league2_id).and_return(2)
            allow(@user).to receive(:league3_id).and_return(1)
            allow(@user).to receive(:league4_id).and_return(4)
            allow(@user).to receive(:league5_id).and_return(1)
         
            put :update, {id: @league.id,:league => {:league_name=>"LeagueName", :commissioner_id=>"2", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""},:email_list => "t@m.com",:player_to_delete_ids => [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]}
            expect(flash[:notice]).to eq("League was successfully updated.")
        end
    end
    describe 'do not add user to league' do  
        before :each do
            allow_message_expectations_on_nil()
             
          user = double(User.new(:id =>4, :num_leagues => 0))
          expect(controller.current_user).to receive(:id).and_return(1)  
          
          @league = double(League)
    
          allow(League).to receive(:find).and_return(@league)
          allow(@league).to receive(:number_members).and_return(0)
         # allow(@league).to receive(:user1_id).and_return(2)
          #allow(@league).to receive(:user2_id).and_return(3)
          #allow(@league).to receive(:user3_id).and_return(4)
         #allow(@league).to receive(:user4_id).and_return(5)
         # allow(@league).to receive(:user5_id).and_return(6)
          #allow(@league).to receive(:user6_id).and_return(7)
          #allow(@league).to receive(:user7_id).and_return(8)
          #allow(@league).to receive(:user8_id).and_return(9)
          #allow(@league).to receive(:user9_id).and_return(10)
          #allow(@league).to receive(:user10_id).and_return(11)
          #allow(@league).to receive(:user11_id).and_return(12)
          #allow(@league).to receive(:user12_id).and_return(13)
          #allow(@league).to receive(:user13_id).and_return(14)
          #allow(@league).to receive(:user14_id).and_return(15)
          #allow(@league).to receive(:user15_id).and_return(16)
          #allow(@league).to receive(:user16_id).and_return(17)
          #allow(@league).to receive(:user17_id).and_return(18)
          #allow(@league).to receive(:user18_id).and_return(19)
          #allow(@league).to receive(:user19_id).and_return(20)
          #allow(@league).to receive(:user20_id).and_return(21)
          allow(controller.current_user).to receive(:id).and_return(1)
          allow(User).to receive(:find).with(2).and_return(user)
          allow(@league).to receive(:user1_id=).and_return(2)
          allow(@league).to receive(:number_members=).and_return(2)
          allow(@league).to receive(:id).and_return(1)
          allow(user).to receive(:num_leagues).and_return(1)
          allow(user).to receive(:league1_id=).and_return(2)
          allow(user).to receive(:num_leagues=).and_return(1)
          allow(user).to receive(:save!)
          allow(@league).to receive(:save!)
          
          allow(user).to receive(:league2_id=).and_return(3)
          allow(user).to receive(:league3_id=).and_return(4)
          allow(user).to receive(:league4_id=).and_return(5)
          allow(user).to receive(:league5_id=).and_return(6)
          
         # expect(League).to receive(:find).with("1").and_return(league)
          #allow(league).to receive(:id).and_return(1)
          #league.user1_id=1
          #current_user.id=10
        end
        it "move to the 2nd if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 3rd if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 4th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 5th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 6th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 7th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 8th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 9th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 10th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 11th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 12th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 13th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 14th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(13)
          allow(@league).to receive(:user14_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 15th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(13)
          allow(@league).to receive(:user14_id).and_return(14)
          allow(@league).to receive(:user15_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 16th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(13)
          allow(@league).to receive(:user14_id).and_return(14)
          allow(@league).to receive(:user15_id).and_return(15)
          allow(@league).to receive(:user16_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 17th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(13)
          allow(@league).to receive(:user14_id).and_return(14)
          allow(@league).to receive(:user15_id).and_return(15)
          allow(@league).to receive(:user16_id).and_return(16)
          allow(@league).to receive(:user17_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 18th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(13)
          allow(@league).to receive(:user14_id).and_return(14)
          allow(@league).to receive(:user15_id).and_return(15)
          allow(@league).to receive(:user16_id).and_return(16)
          allow(@league).to receive(:user17_id).and_return(17)
          allow(@league).to receive(:user18_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 19th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(13)
          allow(@league).to receive(:user14_id).and_return(14)
          allow(@league).to receive(:user15_id).and_return(15)
          allow(@league).to receive(:user16_id).and_return(16)
          allow(@league).to receive(:user17_id).and_return(17)
          allow(@league).to receive(:user18_id).and_return(18)
          allow(@league).to receive(:user19_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
       it "move to the 20th if statement of checking if user is in the league already" do 
          #@league.user2_id == current_user.id
          allow(@league).to receive(:user1_id).and_return(100)
          allow(@league).to receive(:user2_id).and_return(2)
          allow(@league).to receive(:user3_id).and_return(3)
          allow(@league).to receive(:user4_id).and_return(4)
          allow(@league).to receive(:user5_id).and_return(5)
          allow(@league).to receive(:user6_id).and_return(6)
          allow(@league).to receive(:user7_id).and_return(7)
          allow(@league).to receive(:user8_id).and_return(8)
          allow(@league).to receive(:user9_id).and_return(9)
          allow(@league).to receive(:user10_id).and_return(10)
          allow(@league).to receive(:user11_id).and_return(11)
          allow(@league).to receive(:user12_id).and_return(12)
          allow(@league).to receive(:user13_id).and_return(13)
          allow(@league).to receive(:user14_id).and_return(14)
          allow(@league).to receive(:user15_id).and_return(15)
          allow(@league).to receive(:user16_id).and_return(16)
          allow(@league).to receive(:user17_id).and_return(17)
          allow(@league).to receive(:user18_id).and_return(18)
          allow(@league).to receive(:user19_id).and_return(19)
          allow(@league).to receive(:user20_id).and_return(1)
          post :add_user_to_league, {:league_id => 1}
          expect(flash[:notice]).to eq("You are already a member of this league")
       end
   end
   describe "test edit" do
       it 'should edit the league' do
            #expect(League).to receive(:edit)
            user = double(User)
            league = double(League)
            allow(league).to receive(:id).and_return(1)
            allow(League).to receive(:find).and_return(league)
            allow(User).to receive(:find).and_return(user)
            allow(league).to receive(:commissioner_id).and_return(1)
            allow(league).to receive(:conference_settings).and_return("FBS")
            allow(league).to receive(:number_picks_settings).and_return(5)
            allow(user).to receive(:email).and_return("a@b.com")
            allow(user).to receive(:id).and_return(1)
            allow(user).to receive(:first_name).and_return("T")
            allow(user).to receive(:last_name).and_return("P")
            
            allow(league).to receive(:user1_id).and_return(100)
          allow(league).to receive(:user2_id).and_return(2)
          allow(league).to receive(:user3_id).and_return(3)
          allow(league).to receive(:user4_id).and_return(4)
          allow(league).to receive(:user5_id).and_return(5)
          allow(league).to receive(:user6_id).and_return(6)
          allow(league).to receive(:user7_id).and_return(7)
          allow(league).to receive(:user8_id).and_return(8)
          allow(league).to receive(:user9_id).and_return(9)
          allow(league).to receive(:user10_id).and_return(10)
          allow(league).to receive(:user11_id).and_return(11)
          allow(league).to receive(:user12_id).and_return(12)
          allow(league).to receive(:user13_id).and_return(13)
          allow(league).to receive(:user14_id).and_return(14)
          allow(league).to receive(:user15_id).and_return(15)
          allow(league).to receive(:user16_id).and_return(16)
          allow(league).to receive(:user17_id).and_return(17)
          allow(league).to receive(:user18_id).and_return(18)
          allow(league).to receive(:user19_id).and_return(19)
          allow(league).to receive(:user20_id).and_return(1)
            
            get :edit, {id:league.id,:league => {:league_name=>"LeagueName", :commissioner_id=>"2", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}}
       end
   end
  end
  
  
end


