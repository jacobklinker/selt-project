class AddGameTimeColumn < ActiveRecord::Migration
  def change
    add_column :games, :game_time, :datetime
  end
end
