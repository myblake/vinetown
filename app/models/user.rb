class User < ActiveRecord::Base
  has_many :messages
  
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :password
  validates_presence_of :email
  validates_uniqueness_of :email
  
end
