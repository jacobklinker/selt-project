class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.integer :league_id
      t.text :announcement
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps null: false
    end
  end
end
