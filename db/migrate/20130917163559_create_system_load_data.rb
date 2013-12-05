class CreateSystemLoadData < ActiveRecord::Migration
  def change
    create_table :system_load_data do |t|
      t.integer :test_run_id
      t.float :cpu
      t.float :memory
      t.datetime :logged_at

      t.timestamps
    end
  end
end
