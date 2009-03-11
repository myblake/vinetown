class AddOptionsToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :home_page, :boolean
    add_column :posts, :community_page, :boolean
    add_column :posts, :group_id, :integer
  end

  def self.down
    remove_column :posts, :group_id
    remove_column :posts, :community_page
    remove_column :posts, :home_page
  end
end
