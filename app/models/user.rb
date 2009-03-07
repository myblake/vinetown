class User < ActiveRecord::Base
  has_many :messages
  has_many :friends
  has_many :posts, :foreign_key => "user_id"
  has_many :comments
  has_and_belongs_to_many :groups

  validates_presence_of :password
  validates_presence_of :email
  validates_uniqueness_of :email
  
  validate :email_correct?
  # add validation for:
  # dob format
  
  def email_correct?
    unless email=~/.*\@.*\..*/
      errors.add(:email, "Check email address for \"@\" and \".\" characters.")
    end
  end
end
