class User < ActiveRecord::Base
  has_many :messages
  has_many :friends

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
