class AddParamsToTestRun < ActiveRecord::Migration
  def change
  	add_column :test_runs, :from_user, :string
  	add_column :test_runs, :advertise_address, :string
  	add_column :test_runs, :sipp_options, :string
  end
end
