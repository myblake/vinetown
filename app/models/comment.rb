class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :parent, :foreign_key => "parent_id"
  has_many :children, :foreign_key => "parent_id"
  
end
