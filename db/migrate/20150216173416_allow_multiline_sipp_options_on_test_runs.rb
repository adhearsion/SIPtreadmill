class AllowMultilineSippOptionsOnTestRuns < ActiveRecord::Migration
  def up
    change_column :test_runs, :sipp_options, :text
  end

  def down
    change_column :test_runs, :sipp_options, :string
  end
end
