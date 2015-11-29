class AddHomeTeamCoverToGames < ActiveRecord::Migration
  def change
    add_column :games, :homeTeamCover, :boolean
  end
end
