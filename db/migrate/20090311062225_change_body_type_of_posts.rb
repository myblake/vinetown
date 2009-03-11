class ChangeBodyTypeOfPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :body
    add_column :posts, :body, :text
  end

  def self.down
    remove_column :posts, :body
    add_column :posts, :body, :string
  end
end
