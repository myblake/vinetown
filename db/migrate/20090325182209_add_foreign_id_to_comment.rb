class AddForeignIdToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :foreign_id, :integer
    add_column :comments, :type, :string
  end

  def self.down
    remove_column :comments, :foreign_id
    remove_column :comments, :type
  end
end
