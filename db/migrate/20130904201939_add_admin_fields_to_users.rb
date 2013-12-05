class AddAdminFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :admin_mode, :boolean, default: false
    add_column :users, :perma_admin, :boolean, default: false
  end
end
