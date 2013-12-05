class AddUserIdToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :user_id, :integer
  end
end
