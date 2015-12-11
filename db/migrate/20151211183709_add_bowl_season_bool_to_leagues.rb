class AddBowlSeasonBoolToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :bowlSeason, :boolean
  end
end
