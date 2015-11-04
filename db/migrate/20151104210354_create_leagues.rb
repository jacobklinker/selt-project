class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :league_name
      t.references :commissioner, index: true, foreign_key: true
      t.references :current_leader, index: true, foreign_key: true
      t.string :conference_settings
      t.integer :number_picks_settings
      t.integer :number_members
      t.references :user1, index: true, foreign_key: true
      t.references :user2, index: true, foreign_key: true
      t.references :user3, index: true, foreign_key: true
      t.references :user4, index: true, foreign_key: true
      t.references :user5, index: true, foreign_key: true
      t.references :user6, index: true, foreign_key: true
      t.references :user7, index: true, foreign_key: true
      t.references :user8, index: true, foreign_key: true
      t.references :user9, index: true, foreign_key: true
      t.references :user10, index: true, foreign_key: true
      t.references :user11, index: true, foreign_key: true
      t.references :user12, index: true, foreign_key: true
      t.references :user13, index: true, foreign_key: true
      t.references :user14, index: true, foreign_key: true
      t.references :user15, index: true, foreign_key: true
      t.references :user16, index: true, foreign_key: true
      t.references :user17, index: true, foreign_key: true
      t.references :user18, index: true, foreign_key: true
      t.references :user19, index: true, foreign_key: true
      t.references :user20, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
