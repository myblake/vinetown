class CreateAboutUs < ActiveRecord::Migration
  def self.up
    create_table :about_us do |t|
      t.text :text
      t.timestamps
    end
  end

  def self.down
    drop_table :about_us
  end
end
