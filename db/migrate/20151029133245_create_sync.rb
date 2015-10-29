class CreateSync < ActiveRecord::Migration
  def change
    create_table :syncs do |t|
      t.datetime :timestamp
      t.integer  :new_games
      t.integer  :updated_games
      t.integer  :failed_games
      t.boolean  :is_successful
    end
  end
end
