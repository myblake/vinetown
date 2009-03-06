class UserMailer < ActionMailer::Base
  
  def welcome(user)
    subject    'Welcome to Vinetown'
    recipients user.email 
    from       'vinetown@vinetown.com' 
    sent_on    Time.now
    
    body       :user => user
  end

  def forgot_password(user, password)
    subject    'Your Vinetown Password'
    recipients user.email 
    from       'vinetown@vinetown.com'
    sent_on    Time.now
    
    body       :user => user, :password => password
  end

end
