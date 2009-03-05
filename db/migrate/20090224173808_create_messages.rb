class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :sender_user_id
      t.integer :receiver_user_id
      t.string :subject
      t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
