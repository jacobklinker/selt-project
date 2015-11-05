require 'rails_helper'
require 'games_sync_spec_helper'

describe "game background sync" do
  
  describe "syncing with pinnacle sports api" do
    
    before :each do
      allow(Time).to receive(:now).and_return(Time.new("2015-10-29 19:27:32 CST"))
      @sync = Sync.new
      expect(Sync).to receive(:new).and_return(@sync)
    end
    
    it "should handle a single game" do
      expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_1 + XmlResponse.footer)
      expect(Game).to receive(:create).once
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(1)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(0)
      expect(@sync.is_successful).to eq(true)
    end
    
    it "should not have the placeholder rule game at the end of the file" do
      expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_1 + XmlResponse.game_5_bad_time + XmlResponse.footer)
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(1)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(0)
      expect(@sync.is_successful).to eq(true)
    end
    
    describe "when a game between these two teams already exists" do
    
      before :each do
        @game = Game.new()
        @game.home_team = "Pittsburgh U"
        @game.away_team = "North Carolina"
        @game.home_odds = 4
        @game.away_odds = -4
        
        expect(Game).to receive(:find_by).and_return(@game)
        expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_1 + XmlResponse.footer)  
      end
    
      describe "and it finds a game from this week that is not finished yet" do
        
        before :each do 
          @game.is_finished = false
          @game.game_time = "2015-10-29 22:00"
        end
        
        it "should update the games odds when we're at the beginning of the week" do
          expect(GamesSync).to receive(:is_valid_day_to_update_odds).and_return(true)
          
          GamesSync.perform
          
          expect(@sync.updated_games).to eq(1)
          expect(@game.home_odds).to eq(3)
          expect(@game.away_odds).to eq(-3)
        end
        
        it "should not update the games odds when we're nearing the end of the week" do
          expect(GamesSync).to receive(:is_valid_day_to_update_odds).and_return(false)
          
          GamesSync.perform
          
          expect(@game.home_odds).to eq(4)
          expect(@game.away_odds).to eq(-4)
        end
        
        after :each do
          expect(@sync.new_games).to eq(0)
          expect(@sync.updated_games).to eq(1)
          expect(@game.game_time).to eq("2015-10-29 23:00")
        end
        
      end
      
      it "should do nothing to a game when game is already in the db from this week and is finished" do
        @game.is_finished = true
        @game.game_time = "2015-10-29 22:00"
        
        GamesSync.perform
        
        expect(@sync.new_games).to eq(0)
        expect(@sync.updated_games).to eq(0)
        expect(@game.game_time).to eq("2015-10-29 22:00")
        expect(@game.home_odds).to eq(4)
        expect(@game.away_odds).to eq(-4)
      end
      
      it "should add a new game when game is finished and is more than a week ago" do
        @game.is_finished = true
        @game.game_time = "2014-10-29 22:00"
        
        GamesSync.perform
        
        expect(@sync.new_games).to eq(1)
        expect(@sync.updated_games).to eq(0)
        expect(@game.game_time).to eq("2014-10-29 22:00")
        expect(@game.home_odds).to eq(4)
        expect(@game.away_odds).to eq(-4)
      end
      
      after :each do
        expect(@sync.failed_games).to eq(0)
        expect(@sync.is_successful).to eq(true)
      end
      
    end
    
    it "should handle multiple games" do
      expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_1 + XmlResponse.game_2 + XmlResponse.footer)
      expect(Game).to receive(:create).twice
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(2)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(0)
      expect(@sync.is_successful).to eq(true)
    end
    
    it "should fail on a bad game with missing participant" do
      expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_1 + XmlResponse.game_2 + XmlResponse.game_3_bad + XmlResponse.footer)
      expect(Game).to receive(:create).twice
      expect(GamesSync).to receive(:send_error_email).once
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(2)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(1)
      expect(@sync.is_successful).to eq(false)
    end
    
    it "should fail on a bad game with missing spread" do
      expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_4_bad + XmlResponse.footer)
      expect(GamesSync).to receive(:send_error_email).once
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(0)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(1)
      expect(@sync.is_successful).to eq(false)
    end
    
    it "should fail on a game with no period information" do
      expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_6_no_period + XmlResponse.footer)
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(0)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(1)
      expect(@sync.is_successful).to eq(true)
    end
    
    it "should continue processing after a game with no period information" do
      expect(GamesSync).to receive(:get_xml).and_return(XmlResponse.header + XmlResponse.game_1 + XmlResponse.game_6_no_period + XmlResponse.game_2 + XmlResponse.footer)
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(2)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(1)
      expect(@sync.is_successful).to eq(true)
    end
    
    it "should do nothing on a blank response" do
      expect(GamesSync).to receive(:get_xml).and_return("")
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(0)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(0)
      expect(@sync.is_successful).to eq(true)
    end
    
  end
  
  describe "time checking for updating games" do
  
    before :each do
      @time = double(Time)
      expect(Time).to receive(:now).and_return(@time)
    end
    
    it "should allow updating on Sunday" do
      expect(@time).to receive(:wday).and_return(0)
      expect(GamesSync.is_valid_day_to_update_odds).to be_truthy
    end
    
    it "should allow updating on Monday" do
      expect(@time).to receive(:wday).and_return(1)
      expect(GamesSync.is_valid_day_to_update_odds).to be_truthy
    end
    
    it "should allow updating on Tuesday" do
      expect(@time).to receive(:wday).and_return(2)
      expect(GamesSync.is_valid_day_to_update_odds).to be_truthy
    end
    
    it "should not allow updating on Wednesday" do
      expect(@time).to receive(:wday).and_return(3)
      expect(GamesSync.is_valid_day_to_update_odds).to be_falsy
    end
    
    it "should not allow updating on Thursday" do
      expect(@time).to receive(:wday).and_return(4)
      expect(GamesSync.is_valid_day_to_update_odds).to be_falsy
    end
    
    it "should not allow updating on Friday" do
      expect(@time).to receive(:wday).and_return(5)
      expect(GamesSync.is_valid_day_to_update_odds).to be_falsy
    end
    
    it "should not allow updating on Saturday" do
      expect(@time).to receive(:wday).and_return(6)
      expect(GamesSync.is_valid_day_to_update_odds).to be_falsy
    end
    
  end
  
  describe "getting xml from correct url" do
    
    it "should get xml results from pinnacle sports" do
      expect(GamesSync).to receive(:open)
        .with("http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Football&sportsubtype=ncaa")
        .and_return(nil)
      xml = GamesSync.get_xml
      
      expect(xml).to eq(nil)
    end
    
  end
  
  describe "when the sync has failed" do
    
    it "should send an email letting jklinker1@gmail.com know what has happened" do
      mail = double(mail)
      expect(GamesSync).to receive(:create_error_email).and_return(mail)
      expect(mail).to receive(:deliver!)
      GamesSync.send_error_email
    end
    
    it "should create a message to jklinker1@gmail.com" do
      mail = GamesSync.create_error_email
      expect(mail.to).to eq(['jklinker1@gmail.com'])
      expect(mail.from).to eq(['jklinker1@gmail.com'])
    end
    
  end
  
end
