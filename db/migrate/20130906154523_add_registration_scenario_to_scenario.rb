class AddRegistrationScenarioToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :scenario_id, :integer
  end
end
