class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :foreign_key => "parent_id"
  has_many :children, :foreign_key => "parent_id"
  
end

class PostComment < Comment
  belongs_to :post, :foreign_key => "foreign_id"
end

class StatusComment < Comment
  belongs_to :status, :foreign_key => "foreign_id"
end

#
# Makes this way easier down the road, and you know it's gonna happen. 
#
#class PhotoComment < Comment
#  belongs_to :photo, :foreign_key => "foreign_id"
#end