require 'rails_helper'

describe UsersController do

  it "sets the current user" do
      expect(controller).to receive(:current_user)
      post :index
  end
  
  it "should redirect to signin if the current_user is invalid" do 
      expect(controller).to receive(:current_user).and_return(nil)
      post :index
      
      expect(response).to redirect_to(unauthenticated_root_path)
  end
  
  it "should have an empty league array if the user has no leagues" do
    user = User.new
    expect(controller).to receive(:current_user).and_return(user)
    post :index
    
    expect(assigns(:leagues)).to eq []
  end
  
  it "should have one item in the league array if the user has one league" do
    user = User.create
    user.league1_id = 1;
    
    commish = User.create
    commish.first_name = "test"
    commish.last_name = "user"
    
    league = League.new
    league.commissioner_id = 1
    
    expect(League).to receive(:find).with(1).and_return(league)
    expect(User).to receive(:find).with(1).and_return(commish)
    expect(controller).to receive(:current_user).and_return(user)
    
    post :index
    
    expect(assigns(:leagues).length).to eq 1
  end
  
  it "should have multiple items in the league array if the user has more than one league" do
    user = User.create
    user.league1_id = 1;
    user.league2_id = 1;
    
    commish = User.create
    commish.first_name = "test"
    commish.last_name = "user"
    
    league = League.new
    league.commissioner_id = 1
    
    expect(League).to receive(:find).with(1).exactly(2).times.and_return(league)
    expect(User).to receive(:find).with(1).exactly(2).times.and_return(commish)
    expect(controller).to receive(:current_user).and_return(user)
    
    post :index
    
    expect(assigns(:leagues).length).to eq 2
  end
  
end