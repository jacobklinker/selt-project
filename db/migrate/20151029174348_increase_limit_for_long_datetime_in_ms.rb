class IncreaseLimitForLongDatetimeInMs < ActiveRecord::Migration
  def change
    change_column :syncs, :pinnacle_feed_time, :datetime
  end
end
