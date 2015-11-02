class ConvertSpreadsToDecimals < ActiveRecord::Migration
  def change
    change_column :games, :home_odds, :float
    change_column :games, :away_odds, :float
  end
end
