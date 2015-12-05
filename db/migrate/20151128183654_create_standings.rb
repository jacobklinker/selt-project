class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.integer :weeklyScore

      t.timestamps null: false
    end
  end
end
