class ChangeErrorMessageToText < ActiveRecord::Migration
  def up
    change_column :test_runs, :error_message, :text
  end

  def down
    change_column :test_runs, :error_message, :string, limit: 255
  end
end
