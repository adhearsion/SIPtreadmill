class AddErrorLoggingColumnsToTestRuns < ActiveRecord::Migration
  def change
    add_column :test_runs, :error_name, :string
    add_column :test_runs, :error_message, :string
  end
end
