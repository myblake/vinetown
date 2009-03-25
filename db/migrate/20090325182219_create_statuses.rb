class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer :user_id
      t.string :status
      t.timestamps
    end
    remove_column :users, :status
  end

  def self.down
    drop_table :statuses
    add_column :users, :status, :string
  end
end
