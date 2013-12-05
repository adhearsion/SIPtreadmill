class AddSippyCupScenarioToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :sippy_cup_scenario, :text
  end
end
