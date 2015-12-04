class AddPointsEstimateToTiebreakerPicks < ActiveRecord::Migration
  def change
    add_column :tiebreaker_picks, :points_estimate, :integer
  end
end
