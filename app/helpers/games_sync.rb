require 'open-uri'

class GamesSync
  
  def self.perform
    doc = Nokogiri::XML(GamesSync.get_xml())
    feed_time = doc.xpath('/pinnacle_line_feed/PinnacleFeedTime')
    
    sync = Sync.new
    
    sync.pinnacle_feed_time = feed_time.text
    sync.timestamp = Time.now
    
    time = nil
    away = nil
    home = nil
    away_spread = nil
    home_spread = nil
    count = 1
    
    doc.xpath('//event_datetimeGMT | //participant_name | //periods/period[1]/spread/spread_visiting | //periods/period[1]/spread/spread_home').each do |node|
     
      # Find what the next attribute is in the list and compare it to the node.
      # the count is also used to ensure we are getting all of the data per node
      # in the correct order
      if time == nil && node.to_s.start_with?('<event_datetimeGMT>') && count == 1
        time = node.text
      elsif away == nil && node.to_s.start_with?('<participant_name>') && count == 2
        away = node.text
      elsif home == nil && node.to_s.start_with?('<participant_name>') && count == 3
        home = node.text
      elsif away_spread == nil && node.to_s.start_with?('<spread_visiting>') && count == 4
        away_spread = node.text
      elsif home_spread == nil && node.to_s.start_with?('<spread_home>') && count == 5
        home_spread = node.text
        
        # attempt to find any games currently between these two teams in the db
        game = Game.find_by(home_team: home, away_team: away)
        
        if game == nil || game.game_time.to_f < (Time.now.to_f - 60 * 60 * 24 * 7)
          # create a new game if none are found between these teams or it is an
          # older game (such as from last year)
          Game.create(:home_team => home, :away_team => away, :game_time => time, 
                      :home_odds => home_spread, :away_odds => away_spread)
                      
          sync.new_games = sync.new_games + 1
        else
          # update the game with new odds if they have changed and game is still active
          if !game.is_finished
            if game.home_odds != home_spread
              game.home_odds = home_spread
            end
            
            if game.away_odds != away_spread
              game.away_odds = away_spread
            end
            
            if game.game_time != time
              game.game_time = time
            end
            
            game.save
            
            sync.updated_games = sync.updated_games + 1
          end
        end

        time = away = home = away_spread = home_spread = nil
        count = 0
      else
        # we are off, so fail the game
        sync.failed_games = sync.failed_games + 1
        break
      end 
      
      count = count + 1
    end
    
    # fail the sync when necessary
    if sync.failed_games > 0
      sync.is_successful = false
      
      # TODO send email or some other type of notification here to let us know
      # that sync is borked
    end
    
    sync.save
  end
  
  # stubbed out for easier testing
  def self.get_xml
    open("http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Football&sportsubtype=ncaa")
  end
  
end
