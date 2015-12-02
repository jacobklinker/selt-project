class AddStatsToLeaguePicks < ActiveRecord::Migration
  def change
    add_column :league_picks, :wins, :integer
    add_column :league_picks, :losses, :integer
    add_column :league_picks, :pushes, :integer
  end
end
