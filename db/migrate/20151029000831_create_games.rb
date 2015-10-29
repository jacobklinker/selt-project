class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :home_team
      t.string :away_team
      t.int :home_odds
      t.int :away_odds
      t.int :home_score
      t.int :away_score
      t.boolean :is_finished
    end
  end
end
