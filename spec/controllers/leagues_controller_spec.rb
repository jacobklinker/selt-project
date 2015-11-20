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
    
    describe "POST #create" do
      it "should redirect to index with a notice on successful save" do
        allow(User).to receive(:find).and_return(1);
        allow(controller.current_user).to receive(:id).and_return(1);
        League.any_instance.stub(:valid?).and_return(true)
        post :create, :league => {:league_name=>"LeagueName", :commissioner_id=>"1", :current_leader_id=>"", :conference_settings=>"FBS", :number_picks_settings=>"5", :number_members=>"5", :user1_id=>"1", :user2_id=>"", :user3_id=>"", :user4_id=>"", :user5_id=>"", :user6_id=>"", :user7_id=>"", :user8_id=>"", :user9_id=>"", :user10_id=>"", :user11_id=>"", :user12_id=>"", :user13_id=>"", :user14_id=>"", :user15_id=>"", :user16_id=>"", :user17_id=>"", :user18_id=>"", :user19_id=>"", :user20_id=>""}
        expect(assigns(:league)).to eq(be_new_record)
        expect(response).to redirect_to(leagues_path)
      end
    end
  end
end