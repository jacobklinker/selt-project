class CreateTiebreakers < ActiveRecord::Migration
  def change
    create_table :tiebreakers do |t|
      t.references  :league
      t.integer     :week
      t.references  :game
    end
  end
end
