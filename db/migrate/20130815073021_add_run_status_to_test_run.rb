class AddRunStatusToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :run_status, :string, :default => :pending
  end
end
