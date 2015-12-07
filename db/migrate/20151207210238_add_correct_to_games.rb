class AddCorrectToGames < ActiveRecord::Migration
  def change
     add_column :picks, :correctPick, :integer
  end
end
