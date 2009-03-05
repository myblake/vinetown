class AddProfileDataToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_login_at, :timestamp
    add_column :users, :date_of_birth, :timestamp
    add_column :users, :gender, :string
    add_column :users, :hometown, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :users, :status, :string
    add_column :users, :interests, :text
    add_column :users, :favorite_wines, :text
    add_column :users, :favorite_food_and_wine_pairings, :text
    add_column :users, :confirmation, :string
    add_column :users, :confirmed, :boolean
  end

  def self.down
    remove_column :users, :last_login_at
    remove_column :users, :date_of_birth    
    remove_column :users, :gender
    remove_column :users, :hometown
    remove_column :users, :state
    remove_column :users, :country
    remove_column :users, :status
    remove_column :users, :interests
    remove_column :users, :favorite_wines
    remove_column :users, :favorite_food_and_wine_pairings
    remove_column :users, :confirmation
    remove_column :users, :confirmed
  end
end
