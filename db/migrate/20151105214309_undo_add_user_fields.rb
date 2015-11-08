require_relative '20151105212337_add_user_fields'

class UndoAddUserFields < ActiveRecord::Migration
  def change
    revert AddUserFields
  end
end
