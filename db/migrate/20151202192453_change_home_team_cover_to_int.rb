class ChangeHomeTeamCoverToInt < ActiveRecord::Migration
  def change
    change_column :games, :homeTeamCover, :integer
  end
end
