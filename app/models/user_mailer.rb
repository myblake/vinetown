class UserMailer < ActionMailer::Base
  
  def welcome(user)
    subject    'UserMailer#welcome'
    recipients user.email 
    from       'info@vinetown.com' 
    sent_on    Time.now
    
    body       :user => user
  end

  def forgot_password(user, password)
    subject    'UserMailer#forgot_password'
    recipients user.email 
    from       'info@vinetown.com'
    sent_on    Time.now
    
    body       :user => user, :password => password
  end

end
