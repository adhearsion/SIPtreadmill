class AddUsernameToTarget < ActiveRecord::Migration
  def change
    add_column :targets, :ssh_username, :string
  end
end
