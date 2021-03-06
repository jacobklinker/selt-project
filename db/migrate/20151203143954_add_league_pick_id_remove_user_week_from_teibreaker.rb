class AddLeaguePickIdRemoveUserWeekFromTeibreaker < ActiveRecord::Migration
  def change
    remove_column :tiebreaker_picks, :user_id
    remove_column :tiebreaker_picks, :league_id
    remove_column :tiebreaker_picks, :week
    add_reference :tiebreaker_picks, :game, index: true, foreign_key: true
    add_reference :tiebreaker_picks, :league_pick, index: true, foreign_key: true
  end
end
