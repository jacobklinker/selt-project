require 'rails_helper'
 
describe GamesController do
    
    it "should load all games for the index" do
        expect(Game).to receive(:all)
        post :index
    end
    
    describe "updating a game" do
        
        before :each do
            @game = double(Game)
            expect(Game).to receive(:find).with("1").and_return(@game)
        end
        
        it "should load a single game for editing" do
            post :edit, {:id => 1}
        end
        
        it "should load a single game for updating" do
            expect(@game).to receive(:update_attributes!).once
            expect(@game).to receive(:home_team).and_return("Indiana")
            expect(@game).to receive(:away_team).and_return("Iowa")
            post :update, {:id => 1, :game => {:home_score => 0, :away_score => 10, :is_finished => true}}
            expect(flash[:notice]).to eq("Indiana vs Iowa was successfully updated.")
            expect(response).to redirect_to(games_path)
        end
        
    end
    
    describe "work with the current week" do 
        
        before :each do
            time = double(Time)
            allow(Time).to receive(:now).and_return(time)
            expect(time).to receive(:strftime).with("%U").and_return(1)
        end
        
        it "should redirect to league home when submitting picks" do
            allow_message_expectations_on_nil()
            
            user = double(User)
            league = double(League)
    
            expect(controller.current_user).to receive(:id).and_return(1)
            expect(League).to receive(:find).with("1").and_return(league)
            allow(league).to receive(:id).and_return(1)
            
            league_pick = LeaguePick.new(:id => 1)
            game1 = Game.new(:id => 1, :home_team => "Iowa")
            game2 = Game.new(:id => 2, :home_team => "Michigan")
            
            expect(LeaguePick).to receive(:create).with(:league_id => 1, :user_id => 1, :week => 1).and_return(league_pick)
            expect(Game).to receive(:find).with("1").and_return(game1)
            expect(Game).to receive(:find).with("2").and_return(game2)
            
            expect(Pick).to receive(:create).with(:game_id => 1, :league_pick_id => 1, :home_wins => true).once
            expect(Pick).to receive(:create).with(:game_id => 2, :league_pick_id => 1, :home_wins => false).once
            
            post :submit_picks, {:league_id => 1, :picks => {"1" => "Iowa", "2" => "Ohio State"}}
            
            expect(flash[:notice]).to eq("Picks saved successfully!")
            expect(response).to redirect_to(league_path(league))
        end
        
        describe "show picks" do
            
            before :each do
                allow_message_expectations_on_nil()
                
                @league = double(League)
                user = double(User)
                
                expect(League).to receive(:find).with("1").and_return(@league)
                expect(User).to receive(:find).with("1").and_return(user)
                allow(@league).to receive(:id).and_return(1)
                expect(user).to receive(:id).and_return(1)
                
                @where = double(Object)
                @where_my_picks = double(Object)
            end
            
            describe "where I have not made my picks" do
                before :each do
                    expect(@where_my_picks).to receive(:take).and_return(nil)
                end
                
                it "should redirect me to make my picks if I'm trying to view my own" do
                    expect(LeaguePick).to receive(:where).with(league_id: 1, user_id: 1, week: 1).and_return(@where_my_picks)
                    allow(controller.current_user).to receive(:id).and_return(1)
                    post :show_picks, {:league_id => 1, :user_id => 1}
                    expect(response).to redirect_to(games_picks_path(@league))
                end
                
                it "should notify me that I have to make my own picks first" do
                    expect(LeaguePick).to receive(:where).with(league_id: 1, user_id: 2, week: 1).and_return(@where_my_picks)
                    allow(controller.current_user).to receive(:id).and_return(2)
                    post :show_picks, {:league_id => 1, :user_id => 1}
                    expect(response).to render_template("games/make_my_picks_first")
                end
            end
            
            describe "where I have made my picks" do
                
                before :each do
                    expect(LeaguePick).to receive(:where).with(league_id: 1, user_id: 2, week: 1).and_return(@where_my_picks)
                    expect(LeaguePick).to receive(:where).with(league_id: 1, user_id: 1, week: 1).and_return(@where)
                    my_picks = double(LeaguePick)
                    expect(@where_my_picks).to receive(:take).and_return(my_picks)
                    allow(controller.current_user).to receive(:id).and_return(2)
                end
                
                it "should show no picks page when none have been made for a user" do
                    expect(@where).to receive(:take).and_return(nil)
                    post :show_picks, {:league_id => 1, :user_id => 1}
                    expect(response).to render_template("games/no_picks")
                end
                
                it "should render all picks for a player" do
                    league_pick = LeaguePick.new(:id => 1)
                    expect(@where).to receive(:take).and_return(league_pick)
                    
                    pick1 = Pick.new(:game_id => 1, :home_wins => true)
                    pick2 = Pick.new(:game_id => 2, :home_wins => false)
                    picks = [pick1, pick2]
                    where_pick = double(Object)
                    expect(Pick).to receive(:where).with(league_pick_id: 1).and_return(where_pick)
                    expect(where_pick).to receive(:find_each).and_return(picks)
                    
                    game1 = Game.new(:id => 1, :home_team => "Iowa")
                    game2 = Game.new(:id => 2, :home_team => "Michigan")
                    expect(Game).to receive(:find).with(1).and_return(game1)
                    expect(Game).to receive(:find).with(2).and_return(game2)
                    
                    post :show_picks, {:league_id => 1, :user_id => 1}
                    
                    expect(response).to render_template("games/show_picks")
                    # expect(:games.at(0).game).to eq(game1)
                    # expect(:games.at(0).home_wins).to eq(true)
                    # expect(:games.at(1).game).to eq(game2)
                    # expect(:games.at(1).game).to eq(false)
                end
            end
            
        end
        
    end
    
    describe "display games you can pick" do
        
        it "should display FBS games in the future" do
            games = []
            game1 = Game.new(:game_time => Time.now + 1000)
            game2 = Game.new(:game_time => Time.now + 2000)
            games << game1
            games << game2
            
            league = League.new(:number_picks_settings => 5, :conference_settings => "FBS")
            
            expect(League).to receive(:find).with("1").and_return(league)
            expect(Game).to receive(:all).and_return(games)
            
            post :picks, {:league_id => 1}
            
            expect(assigns(:games)).to eq games
        end
        
        it "should not display games in the past" do
            games = []
            game1 = Game.new(:game_time => Time.now - 1000)
            game2 = Game.new(:game_time => Time.now + 2000)
            games << game1
            games << game2
            
            league = League.new(:number_picks_settings => 5, :conference_settings => "FBS")
            
            expect(League).to receive(:find).with("1").and_return(league)
            expect(Game).to receive(:all).and_return(games)
            
            post :picks, {:league_id => 1}
            
            expect(assigns(:games)).to eq [game2]
        end
        
    end
    
end