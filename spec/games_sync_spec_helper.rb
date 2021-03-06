class XmlResponse
  def self.header 
    """
    <pinnacle_line_feed>
      <PinnacleFeedTime>1446127425768</PinnacleFeedTime>
      <lastContest>36003397</lastContest>
      <lastGame>235523800</lastGame>
      <events>
    """
  end
  
  def self.footer 
    """
      </events>
    </pinnacle_line_feed>
    """
  end

  def self.game_1
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
  end

  def self.game_2
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
  end

  def self.game_3_bad
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
  end

  def self.game_4_bad
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
  end
  
  def self.game_5_bad_time
    """
    <event>
      <event_datetimeGMT>2016-01-31 16:00</event_datetimeGMT>
      <gamenumber>495534180</gamenumber>
      <sporttype>Football</sporttype>
      <league>NCAA</league>
      <IsLive>No</IsLive>
      <participants>
        <participant>
          <participant_name>All NCAA Games will have</participant_name>
          <contestantnum>999</contestantnum>
          <rotnum>999</rotnum>
          <visiting_home_draw>Visiting</visiting_home_draw>
        </participant>
        <participant>
          <participant_name>2nd Half Wagering</participant_name>
          <contestantnum>1000</contestantnum>
          <rotnum>1000</rotnum>
          <visiting_home_draw>Home</visiting_home_draw>
        </participant>
      </participants>
      <periods>
        <period>
          <period_number>2</period_number>
          <period_description>2nd Half</period_description>
          <periodcutoff_datetimeGMT>2016-01-31 16:00</periodcutoff_datetimeGMT>
          <period_status>H</period_status>
          <period_update>offline</period_update>
          <spread_maximum>2000</spread_maximum>
          <moneyline_maximum>1000</moneyline_maximum>
          <total_maximum>1000</total_maximum>
          <spread>
            <spread_visiting>0</spread_visiting>
            <spread_adjust_visiting>-106</spread_adjust_visiting>
            <spread_home>0</spread_home>
            <spread_adjust_home>-106</spread_adjust_home>
          </spread>
        </period>
      </periods>
    </event>
    """
  end
  
  def self.game_6_no_period
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
      <periods> </periods>
    </event>
    """
  end
  
end