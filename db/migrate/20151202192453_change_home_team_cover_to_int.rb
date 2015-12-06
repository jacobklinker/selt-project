class ChangeHomeTeamCoverToInt < ActiveRecord::Migration
  def change
    remove_column :games, :homeTeamCover
    add_column :games, :homeTeamCover, :integer
  end
end
