class Friend < ActiveRecord::Base
  belongs_to :user, :foreign_key => "user_id_1"
  belongs_to :user, :foreign_key => "user_id_2"

  validates_presence_of :user_id_1
  validates_presence_of :user_id_2
  
  validate :does_not_exist?
  validate :not_friends_with_self?
  
  def not_friends_with_self?
    if user_id_1 == user_id_2
      errors.add(:user_id_2, "You cannot be friends with yourself.")
    end
  end
  
  def does_not_exist?
    if @friend = Friend.find(:first, :conditions => ["(user_id_1=? and user_id_2=?) or (user_id_1=? and user_id_2=?)",user_id_1,user_id_2,user_id_2,user_id_1])
      if @friend.accepted || @friend.rejected || @friend.id != id
	      errors.add(:user_id_2, "You are already friends with this user")
      end
    end
  end
  
end
