require 'rails_helper'

describe LeaguesController do

  it "index should load all the leagues" do
      expect(League).to receive(:all)
      post :index
  end
  
  describe "viewing a valid league" do 
    before :each do 
      @user = double(User)
      controller.current_user = @user
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
        expect(@user).to receive(:id).and_return(0)
        
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
        expect(@user).to receive(:id).and_return(0)
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
end