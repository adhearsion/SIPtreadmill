class AddRegistrationScenarioIdToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :registration_scenario_id, :integer
  end
end
