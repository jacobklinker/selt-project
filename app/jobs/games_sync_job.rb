require 'open-uri'

class GamesSyncJob
  
  def perform
    doc = Nokogiri::HTML(open("http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Football&sportsubtype=ncaa"))
    feed_time = doc.xpath('/pinnacle_line_feed/PinnacleFeedTime')
    sync = Sync.new
    
    sync.pinnacle_feed_time = feed_time
    sync.timestamp = Time.now
    sync.new_games = 0
    sync.updated_games = 0
    sync.failed_games = 0
    sync.is_successful = true
    
    # TODO perform nokogiri processing here
    
    sync.save
  end
  
end
