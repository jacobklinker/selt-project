class CreateGames < ActiveRecord::Migration
  def change
    drop_table :games
    create_table :games do |t|
      t.string  :home_team
      t.string  :away_team
      t.integer :home_odds
      t.integer :away_odds
      t.integer :home_score
      t.integer :away_score
      t.boolean :is_finished
    end
  end
end
