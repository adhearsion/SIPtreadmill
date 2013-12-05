class AddResponseTimeToSippData < ActiveRecord::Migration
  def change
    add_column :sipp_data, :response_time, :string
  end
end
