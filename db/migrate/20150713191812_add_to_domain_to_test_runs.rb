class AddToDomainToTestRuns < ActiveRecord::Migration
  def change
    rename_column :test_runs, :to_user, :to
  end
end
