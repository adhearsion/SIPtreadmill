class AddReportsToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :summary_report, :text
    add_column :test_runs, :errors_report, :text
  end
end
