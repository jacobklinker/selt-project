class AddDefaultsToScoreSync < ActiveRecord::Migration
  def change
    change_column :score_syncs, :tweets_found, :integer, :default => 0
    change_column :score_syncs, :tweets_used, :integer, :default => 0
    change_column :score_syncs, :is_successful, :boolean, :default => true
  end
end
