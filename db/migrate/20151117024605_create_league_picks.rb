class CreateLeaguePicks < ActiveRecord::Migration
  def change
    create_table :league_picks do |t|
      t.references  :user
      t.references  :league
      t.integer     :week
    end
  end
end
