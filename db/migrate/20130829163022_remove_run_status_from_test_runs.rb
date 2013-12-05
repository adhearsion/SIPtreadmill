class RemoveRunStatusFromTestRuns < ActiveRecord::Migration
  def up
    remove_column :test_runs, :run_status
  end

  def down
    add_column :test_runs, :run_status, :integer
  end
end
