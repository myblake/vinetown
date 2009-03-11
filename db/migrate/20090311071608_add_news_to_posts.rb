class AddNewsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :news, :boolean
  end

  def self.down
    remove_column :posts, :news
  end
end
