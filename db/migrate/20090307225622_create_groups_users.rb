class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users do |t|
      t.integer :user_id
      t.integer :group_id
    end
  end

  def self.down
  end
end
