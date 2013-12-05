class AddEnqueuedAtStartedAtCompletedAtStateToTestRuns < ActiveRecord::Migration
  def change
    add_column :test_runs, :state, :string
    add_column :test_runs, :enqueued_at, :timestamp
    add_column :test_runs, :started_at, :timestamp
    add_column :test_runs, :completed_at, :timestamp
  end
end
