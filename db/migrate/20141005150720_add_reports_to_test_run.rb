class AddReportsToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :summary_report, :text
    add_column :test_runs, :errors_report_file, :string
    add_column :test_runs, :stats_file, :string
  end
end
