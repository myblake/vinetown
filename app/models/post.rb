class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :post_comments, :foreign_key => "foreign_id"
end
