class AddLeaguesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :league1_id, :integer
    add_column :users, :league2_id, :integer
    add_column :users, :league3_id, :integer
    add_column :users, :league4_id, :integer
    add_column :users, :league5_id, :integer
    add_column :users, :num_leagues, :integer ,default: 0
  end
end
