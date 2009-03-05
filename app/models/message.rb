class Message < ActiveRecord::Base
  belongs_to :user, :foreign_key => "sender_user_id"
  belongs_to :user, :foreign_key => "receiver_user_id"
  
  validates_presence_of :message
  validate :didnt_mail_self?
  
  private
  def didnt_mail_self?
    if (receiver_user_id == sender_user_id)
      errors.add(:receiver_user_id, "No need to mail yourself.")
    end
  end
  
end
