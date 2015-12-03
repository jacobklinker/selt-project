class CreateWeeklyWinners < ActiveRecord::Migration
  def change
    create_table :weekly_winners do |t|
      t.integer :league_id
      t.integer :week
      t.integer :year
      t.text :winners

      t.timestamps null: false
    end
  end
end
