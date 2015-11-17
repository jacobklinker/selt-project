class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.references  :game
      t.boolean     :home_wins
      t.references  :league_pick
    end
  end
end
