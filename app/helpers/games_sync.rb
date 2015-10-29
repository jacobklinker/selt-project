require 'open-uri'

class GamesSync
  
  def perform
    doc = Nokogiri::XML(GamesSync.get_xml())
    feed_time = doc.xpath('/pinnacle_line_feed/PinnacleFeedTime')
    puts feed_time.text
    
    sync = Sync.new
    
    sync.pinnacle_feed_time = feed_time
    sync.timestamp = Time.now
    sync.new_games = 0
    sync.updated_games = 0
    sync.failed_games = 0
    sync.is_successful = true
    
    # TODO perform nokogiri processing here
    nodes = doc.xpath('//event_datetimeGMT or //participant_name or //spread_visiting or //spread_home')
    puts nodes
    
    sync.save
  end
  
  def self.get_xml
    open("http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Football&sportsubtype=ncaa")
  end
  
end
