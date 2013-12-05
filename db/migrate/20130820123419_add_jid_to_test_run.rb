class AddJidToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :jid, :string
  end
end
