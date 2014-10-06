class AddRateScalingToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :calls_per_second_incr, :integer
    add_column :profiles, :calls_per_second_interval, :integer
    add_column :profiles, :calls_per_second_max, :integer
  end
end
