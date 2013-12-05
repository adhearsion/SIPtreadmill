class RemoveRegistrationScenarioIdFromTestRun < ActiveRecord::Migration
  def up
    remove_column :test_runs, :registration_scenario_id
  end

  def down
    add_column :test_runs, :registration_scenario_id, :integer
  end
end
