class CreateTestRuns < ActiveRecord::Migration
  def change
    create_table :test_runs do |t|
      t.string :name
      t.text :description
      t.integer :scenario_id
      t.integer :profile_id
      t.integer :target_id

      t.timestamps
    end
  end
end
