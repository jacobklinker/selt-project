class AddHomeTeamCover2ToGames < ActiveRecord::Migration
  def change
    add_column :games, :homeTeamCover2, :integer
  end
end
