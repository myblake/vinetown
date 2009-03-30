class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :posts
  has_many :comments
  validates_uniqueness_of :name
  
end
