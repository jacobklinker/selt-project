class AddWeeklyTotalToLeaguePicks < ActiveRecord::Migration
  def change
    add_column :league_picks, :weeklyTotal, :integer
  end
end
