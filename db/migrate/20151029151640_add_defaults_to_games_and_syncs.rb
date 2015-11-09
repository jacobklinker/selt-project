class AddDefaultsToGamesAndSyncs < ActiveRecord::Migration
  def change
    change_column :games, :home_team, :string, :null => false
    change_column :games, :away_team, :string, :null => false
    change_column :games, :is_finished, :boolean, :default => false
    change_column :syncs, :new_games, :integer, :default => 0
    change_column :syncs, :updated_games, :integer, :default => 0
    change_column :syncs, :failed_games, :integer, :default => 0
    change_column :syncs, :is_successful, 'boolean USING CAST(is_successful AS boolean)', :default => true
  end
end
