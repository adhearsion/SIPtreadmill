class AddReceiverToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :receiver, :boolean, :default => false
  end
end
