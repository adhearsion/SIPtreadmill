class RemovePermaAdminFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :perma_admin
  end

  def down
    add_column :users, :perma_admin, :boolean, default: false
  end
end
