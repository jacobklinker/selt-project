class AddColumnCorrectPickToPicks < ActiveRecord::Migration
  def change
    add_column :picks, :correct_pick, :integer
  end
end
