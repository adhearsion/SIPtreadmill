class AddUserIdToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :user_id, :integer
  end
end
