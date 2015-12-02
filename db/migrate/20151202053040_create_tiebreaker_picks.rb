class CreateTiebreakerPicks < ActiveRecord::Migration
  def change
    create_table :tiebreaker_picks do |t|
      t.references  :user
      t.references  :league
      t.integer     :week
    end
  end
end
