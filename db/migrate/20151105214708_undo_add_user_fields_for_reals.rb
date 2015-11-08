class UndoAddUserFieldsForReals < ActiveRecord::Migration
  def change
    remove_column :users, :fist_name
    remove_column :users, :last_name
  end
end
