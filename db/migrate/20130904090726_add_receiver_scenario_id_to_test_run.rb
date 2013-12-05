class AddReceiverScenarioIdToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :receiver_scenario_id, :integer
  end
end
