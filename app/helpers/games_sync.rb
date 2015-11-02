require 'open-uri'

# This service is used to grab an XML file from Pinnacle Sports that contains
# current week games and the betting odds for those games. This feed does not
# contain scores for the teams once a game has begun or has finished
# unfortunately, that information will need to come from somewhere else.
class GamesSync
  
  def self.perform
    # grab the document and save the feed time for the sync.
    doc = Nokogiri::XML(GamesSync.get_xml())
    feed_time = doc.xpath('/pinnacle_line_feed/PinnacleFeedTime')
    
    sync = Sync.new
    
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
          
          if home != "2nd Half Wagering"
            Game.create(:home_team => home, :away_team => away, :game_time => time, 
                        :home_odds => home_spread, :away_odds => away_spread)
                        
            sync.new_games = sync.new_games + 1
          end
        else
          # update the game with new odds if they have changed and game is still active
          if !game.is_finished
            updated = false
            
            if is_valid_day_to_update_odds
              if game.home_odds != home_spread.to_f
                game.home_odds = home_spread
                updated = true
              end
              
              if game.away_odds != away_spread.to_f
                game.away_odds = away_spread
                updated = true
              end
            end
            
            if game.game_time != Time.new(time)
              game.game_time = time
              updated = true
            end
            
            # Don't log that the game was updated if nothing actually
            # changed on it! Makes the logging on the syncs controller clearer
            if updated
              game.save
              sync.updated_games = sync.updated_games + 1
            end
          end
        end

        time = away = home = away_spread = home_spread = nil
        count = 0
      else
        # we are off, so fail the game
        sync.failed_games = sync.failed_games + 1
        
        if node.to_s.start_with?('<event_datetimeGMT>')
          # reset the fields. This failed state will occur when
          # there isn't an odds associated with a game, so it will
          # skip the spread nodes and go back to the event time node.
          # save that time and continue moving through as we would
          # so that we stay on track.
          away = home = away_spread = home_spread = nil
          time = node.text
          count = 1
        else
          # mark sync as completely broken!
          sync.is_successful = false
          break
        end
      end 
      
      count = count + 1
    end
    
    # everything should be reset after successful syncs. If it isn't then there
    # is data left over from the last game that didn't get processesed and this
    # should be marked as a failed game.
    if (time != nil || away != nil || home != nil || away_spread != nil || home_spread != nil) && sync.failed_games == 0
      sync.failed_games = sync.failed_games + 1
    end
    
    # fail the sync when necessary
    if !sync.is_successful
      # TODO send email or some other type of notification here to let us know
      # that sync is borked
    end
    
    sync.save
  end
  
  # stubbed out for easier testing
  def self.get_xml
    open("http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Football&sportsubtype=ncaa")
  end
  
  # valid days for users to update odds are Sunday-Tuesday. After this period,
  # users will be able to start choosing games and all of the odds need to be
  # equal for all games and users.
  def self.is_valid_day_to_update_odds
    time = Time.now
    return time.wday <= 2
  end
  
end
