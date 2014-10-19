class AddToUserToTestRuns < ActiveRecord::Migration
  def change
    add_column :test_runs, :to_user, :string
  end
end
