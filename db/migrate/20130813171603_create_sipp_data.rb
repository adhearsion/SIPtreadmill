class CreateSippData < ActiveRecord::Migration
  def change
    create_table :sipp_data do |t|
      t.integer :test_run_id
      t.time :time
      t.integer :successful_calls
      t.integer :failed_calls
      t.integer :total_calls
      t.float :cps
      t.integer :concurrent_calls
      t.float :avg_call_duration

      t.timestamps
    end
  end
end
