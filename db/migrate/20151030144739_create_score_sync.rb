class CreateScoreSync < ActiveRecord::Migration
  def change
    create_table :score_syncs do |t|
      t.datetime :sync_start
      t.integer  :tweets_found
      t.integer  :tweets_used
      t.boolean  :is_successful
    end
  end
end
