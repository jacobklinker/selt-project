class AddPinnacleFeedTimeToSyncs < ActiveRecord::Migration
  def change
    add_column :syncs, :pinnacle_feed_time, :integer
  end
end
