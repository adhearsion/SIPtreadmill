class AddUserIdToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :user_id, :integer
  end
end
