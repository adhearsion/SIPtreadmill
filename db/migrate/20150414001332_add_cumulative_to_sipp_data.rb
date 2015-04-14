class AddCumulativeToSippData < ActiveRecord::Migration
  def change
    add_column :sipp_data, :successful_calls_cumulative, :integer
    add_column :sipp_data, :failed_calls_cumulative, :integer
    add_column :sipp_data, :avg_call_duration_cumulative, :float
  end
end
