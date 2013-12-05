class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.integer :scenario_id
      t.integer :max_calls
      t.integer :calls_per_second
      t.integer :max_concurrent

      t.timestamps
    end
  end
end
