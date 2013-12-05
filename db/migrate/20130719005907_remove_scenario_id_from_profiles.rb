class RemoveScenarioIdFromProfiles < ActiveRecord::Migration
  def up
    remove_column :profiles, :scenario_id
  end

  def down
    add_column :profiles, :scenario_id, :integer
  end
end
