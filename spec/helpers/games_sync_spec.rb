require 'rails_helper'

describe "game background sync" do
  
  response_header = """<pinnacle_line_feed>
                          <PinnacleFeedTime>1446127425768</PinnacleFeedTime>
                          <lastContest>36003397</lastContest>
                          <lastGame>235523800</lastGame>
                          <events>"""

  response_footer = """</events>
                      </pinnacle_line_feed>"""

  game_1 = 
  """
<event>
  <event_datetimeGMT>2015-10-29 23:00</event_datetimeGMT>
  <gamenumber>513773103</gamenumber>
  <sporttype>Football</sporttype>
  <league>NCAA</league>
  <IsLive>No</IsLive>
  <participants>
    <participant>
      <participant_name>North Carolina</participant_name>
      <contestantnum>103</contestantnum>
      <rotnum>103</rotnum>
      <visiting_home_draw>Visiting</visiting_home_draw>
    </participant>
    <participant>
      <participant_name>Pittsburgh U</participant_name>
      <contestantnum>104</contestantnum>
      <rotnum>104</rotnum>
      <visiting_home_draw>Home</visiting_home_draw>
    </participant>
  </participants>
  <periods>
    <period>
      <period_number>0</period_number>
      <period_description>Game</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>5000</spread_maximum>
      <moneyline_maximum>3000</moneyline_maximum>
      <total_maximum>2000</total_maximum>
      <moneyline>
        <moneyline_visiting>-133</moneyline_visiting>
        <moneyline_home>118</moneyline_home>
      </moneyline>
      <spread>
        <spread_visiting>-3</spread_visiting>
        <spread_adjust_visiting>107</spread_adjust_visiting>
        <spread_home>3</spread_home>
        <spread_adjust_home>-120</spread_adjust_home>
      </spread>
      <total>
        <total_points>54.5</total_points>
        <over_adjust>-102</over_adjust>
        <under_adjust>-110</under_adjust>
      </total>
    </period>
    <period>
      <period_number>1</period_number>
      <period_description>1st Half</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>1000</spread_maximum>
      <moneyline_maximum>500</moneyline_maximum>
      <total_maximum>500</total_maximum>
      <moneyline>
        <moneyline_visiting>-133</moneyline_visiting>
        <moneyline_home>118</moneyline_home>
      </moneyline>
      <spread>
        <spread_visiting>-1.5</spread_visiting>
        <spread_adjust_visiting>-102</spread_adjust_visiting>
        <spread_home>1.5</spread_home>
        <spread_adjust_home>-110</spread_adjust_home>
      </spread>
      <total>
        <total_points>27.5</total_points>
        <over_adjust>-114</over_adjust>
        <under_adjust>101</under_adjust>
      </total>
    </period>
    <period>
      <period_number>3</period_number>
      <period_description>1st Quarter</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>500</spread_maximum>
      <moneyline_maximum>500</moneyline_maximum>
      <total_maximum>500</total_maximum>
      <moneyline>
        <moneyline_visiting>-125</moneyline_visiting>
        <moneyline_home>107</moneyline_home>
      </moneyline>
      <spread>
        <spread_visiting>-0.5</spread_visiting>
        <spread_adjust_visiting>107</spread_adjust_visiting>
        <spread_home>0.5</spread_home>
        <spread_adjust_home>-125</spread_adjust_home>
      </spread>
      <total>
        <total_points>10.5</total_points>
        <over_adjust>-120</over_adjust>
        <under_adjust>103</under_adjust>
      </total>
    </period>
  </periods>
</event>
"""

  game_2 = 
  """
<event>
  <event_datetimeGMT>2015-10-29 22:00</event_datetimeGMT>
  <gamenumber>513773103</gamenumber>
  <sporttype>Football</sporttype>
  <league>NCAA</league>
  <IsLive>No</IsLive>
  <participants>
    <participant>
      <participant_name>Maryland</participant_name>
      <contestantnum>103</contestantnum>
      <rotnum>103</rotnum>
      <visiting_home_draw>Visiting</visiting_home_draw>
    </participant>
    <participant>
      <participant_name>Hawkeyes</participant_name>
      <contestantnum>104</contestantnum>
      <rotnum>104</rotnum>
      <visiting_home_draw>Home</visiting_home_draw>
    </participant>
  </participants>
  <periods>
    <period>
      <period_number>0</period_number>
      <period_description>Game</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>5000</spread_maximum>
      <moneyline_maximum>3000</moneyline_maximum>
      <total_maximum>2000</total_maximum>
      <moneyline>
        <moneyline_visiting>-133</moneyline_visiting>
        <moneyline_home>118</moneyline_home>
      </moneyline>
      <spread>
        <spread_visiting>-3</spread_visiting>
        <spread_adjust_visiting>107</spread_adjust_visiting>
        <spread_home>3</spread_home>
        <spread_adjust_home>-120</spread_adjust_home>
      </spread>
      <total>
        <total_points>54.5</total_points>
        <over_adjust>-102</over_adjust>
        <under_adjust>-110</under_adjust>
      </total>
    </period>
    <period>
      <period_number>1</period_number>
      <period_description>1st Half</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>1000</spread_maximum>
      <moneyline_maximum>500</moneyline_maximum>
      <total_maximum>500</total_maximum>
      <moneyline>
        <moneyline_visiting>-133</moneyline_visiting>
        <moneyline_home>118</moneyline_home>
      </moneyline>
      <spread>
        <spread_visiting>-1.5</spread_visiting>
        <spread_adjust_visiting>-102</spread_adjust_visiting>
        <spread_home>1.5</spread_home>
        <spread_adjust_home>-110</spread_adjust_home>
      </spread>
      <total>
        <total_points>27.5</total_points>
        <over_adjust>-114</over_adjust>
        <under_adjust>101</under_adjust>
      </total>
    </period>
    <period>
      <period_number>3</period_number>
      <period_description>1st Quarter</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>500</spread_maximum>
      <moneyline_maximum>500</moneyline_maximum>
      <total_maximum>500</total_maximum>
      <moneyline>
        <moneyline_visiting>-125</moneyline_visiting>
        <moneyline_home>107</moneyline_home>
      </moneyline>
      <spread>
        <spread_visiting>-0.5</spread_visiting>
        <spread_adjust_visiting>107</spread_adjust_visiting>
        <spread_home>0.5</spread_home>
        <spread_adjust_home>-125</spread_adjust_home>
      </spread>
      <total>
        <total_points>10.5</total_points>
        <over_adjust>-120</over_adjust>
        <under_adjust>103</under_adjust>
      </total>
    </period>
  </periods>
</event>
"""

  game_3_bad = 
  """
<event>
  <event_datetimeGMT>2015-10-29 22:00</event_datetimeGMT>
  <gamenumber>513773103</gamenumber>
  <sporttype>Football</sporttype>
  <league>NCAA</league>
  <IsLive>No</IsLive>
  <participants>
    <participant>
      <participant_name>Maryland</participant_name>
      <contestantnum>103</contestantnum>
      <rotnum>103</rotnum>
      <visiting_home_draw>Visiting</visiting_home_draw>
    </participant>
  </participants>
  <periods>
    <period>
      <period_number>0</period_number>
      <period_description>Game</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>5000</spread_maximum>
      <moneyline_maximum>3000</moneyline_maximum>
      <total_maximum>2000</total_maximum>
      <moneyline>
        <moneyline_visiting>-133</moneyline_visiting>
        <moneyline_home>118</moneyline_home>
      </moneyline>
      <spread>
        <spread_visiting>-3</spread_visiting>
        <spread_adjust_visiting>107</spread_adjust_visiting>
        <spread_home>3</spread_home>
        <spread_adjust_home>-120</spread_adjust_home>
      </spread>
      <total>
        <total_points>54.5</total_points>
        <over_adjust>-102</over_adjust>
        <under_adjust>-110</under_adjust>
      </total>
    </period>
  </periods>
</event>
"""

  game_4_bad = 
  """
<event>
  <event_datetimeGMT>2015-10-29 22:00</event_datetimeGMT>
  <gamenumber>513773103</gamenumber>
  <sporttype>Football</sporttype>
  <league>NCAA</league>
  <IsLive>No</IsLive>
  <participants>
    <participant>
      <participant_name>Maryland</participant_name>
      <contestantnum>103</contestantnum>
      <rotnum>103</rotnum>
      <visiting_home_draw>Visiting</visiting_home_draw>
    </participant>
    <participant>
      <participant_name>Hawkeyes</participant_name>
      <contestantnum>104</contestantnum>
      <rotnum>104</rotnum>
      <visiting_home_draw>Home</visiting_home_draw>
    </participant>
  </participants>
  <periods>
    <period>
      <period_number>0</period_number>
      <period_description>Game</period_description>
      <periodcutoff_datetimeGMT>2015-10-29 23:00</periodcutoff_datetimeGMT>
      <period_status>I</period_status>
      <period_update>open</period_update>
      <spread_maximum>5000</spread_maximum>
      <moneyline_maximum>3000</moneyline_maximum>
      <total_maximum>2000</total_maximum>
      <moneyline>
        <moneyline_visiting>-133</moneyline_visiting>
        <moneyline_home>118</moneyline_home>
      </moneyline>
      <spread>
        <spread_adjust_visiting>107</spread_adjust_visiting>
        <spread_home>3</spread_home>
        <spread_adjust_home>-120</spread_adjust_home>
      </spread>
      <total>
        <total_points>54.5</total_points>
        <over_adjust>-102</over_adjust>
        <under_adjust>-110</under_adjust>
      </total>
    </period>
  </periods>
</event>
"""
  
  describe "syncing with pinnacle sports api" do
    
    before :each do
      @sync = Sync.new
      expect(Sync).to receive(:new).and_return(@sync)
    end
    
    it "should handle a single game" do
      expect(GamesSync).to receive(:get_xml).and_return(response_header + game_1 + response_footer)
      expect(Game).to receive(:create).once
      
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
        @game.game_time = "2015-10-29 22:00"
        @game.home_odds = 4
        @game.away_odds = -4
      end
    
      it "should update a single game when game already exists from this season" do
        @game.is_finished = false
        
        expect(GamesSync).to receive(:get_xml).and_return(response_header + game_1 + response_footer)
        expect(Game).to receive(:find_by).and_return(@game)
        
        GamesSync.perform
        
        expect(@sync.new_games).to eq(0)
        expect(@sync.updated_games).to eq(1)
        expect(@game.game_time).to eq("2015-10-29 23:00")
        expect(@game.home_odds).to eq(3)
        expect(@game.away_odds).to eq(-3)
      end
      
      it "should add a new game when game is finished" do
        @game.is_finished = true
        
        expect(GamesSync).to receive(:get_xml).and_return(response_header + game_1 + response_footer)
        expect(Game).to receive(:find_by).and_return(@game)
        
        GamesSync.perform
        
        expect(@sync.new_games).to eq(1)
        expect(@sync.updated_games).to eq(0)
        expect(@game.game_time).to eq("2015-10-29 22:00")
        expect(@game.home_odds).to eq(4)
        expect(@game.away_odds).to eq(-4)
      end
      
      after :each do
        expect(@sync.failed_games).to eq(0)
        expect(@sync.is_successful).to eq(true)
      end
      
    end
    
    it "should handle multiple games" do
      expect(GamesSync).to receive(:get_xml).and_return(response_header + game_1 + game_2 + response_footer)
      expect(Game).to receive(:create).twice
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(2)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(0)
      expect(@sync.is_successful).to eq(true)
    end
    
    it "should fail on a bad game with missing participant" do
      expect(GamesSync).to receive(:get_xml).and_return(response_header + game_1 + game_2 + game_3_bad + response_footer)
      expect(Game).to receive(:create).twice
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(2)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(1)
      expect(@sync.is_successful).to eq(false)
    end
    
    it "should fail on a bad game with missing spread" do
      expect(GamesSync).to receive(:get_xml).and_return(response_header + game_4_bad + response_footer)
      
      GamesSync.perform
      
      expect(@sync.new_games).to eq(0)
      expect(@sync.updated_games).to eq(0)
      expect(@sync.failed_games).to eq(1)
      expect(@sync.is_successful).to eq(false)
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
  
end
