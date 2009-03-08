class AddAdminToGroupsUsers < ActiveRecord::Migration
  def self.up
    add_column :groups_users, :admin, :boolean
  end

  def self.down
    remove_column :groups_users, :admin
  end
end
