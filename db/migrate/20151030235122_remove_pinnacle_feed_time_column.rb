class RemovePinnacleFeedTimeColumn < ActiveRecord::Migration
  def change
    remove_column :syncs, :pinnacle_feed_time
  end
end
