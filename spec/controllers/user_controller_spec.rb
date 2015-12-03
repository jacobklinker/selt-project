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
  
  it "should have an empty announcement array if the leagues have none" do
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
    
    expect(assigns(:announcements)).to eq []
  end
  
  it "should load the announcement array if the leagues have announcements" do
    ann = Announcement.new
    ann.announcement = "test announcement" 
    
    user = User.create
    user.league1_id = 1;
    
    commish = User.create
    commish.first_name = "test"
    commish.last_name = "user"
    
    league = League.new
    league.commissioner_id = 1
    
    now = DateTime.now
    expect(DateTime).to receive(:now).and_return(now).twice
    
    expect(Announcement).to receive(:where).with("league_id = 1 AND start_date <= '#{now.beginning_of_day}' AND end_date >= '#{now.end_of_day}'").and_return([ann])
    
    expect(League).to receive(:find).with(1).and_return(league)
    expect(User).to receive(:find).with(1).and_return(commish)
    expect(controller).to receive(:current_user).and_return(user)
    
    post :index
    
    expect(assigns(:announcements).length).to eq 1
  end 
  
end