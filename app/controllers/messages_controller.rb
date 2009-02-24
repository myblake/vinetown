class MessagesController < ApplicationController
  def inbox
    @messages = Message.find(:all, :conditions => ["receiver_user_id=?",session[:user_id]], :order => "created_at DESC")
    @messages.each do |m|
      if m.subject.nil?
        m.subject = "(no subject)"
      end
    end
  end
  
  def sent_messages
    @messages = Message.find(:all, :conditions => ["sender_user_id=?",session[:user_id]], :order => "created_at DESC")
  end
  
  def send_message
    @value = params[:receiver_username]
  end
  
  def send_message_backend
    receiver = User.find(:first, :conditions => ["username=?",params[:message][:receiver_username]])
    
    if receiver.nil?
      flash[:notice] = "Could not find user #{params[:message][:receiver_username]}."
      redirect_to :action => :send_message
      return
    end
    
    if session[:user_id] == receiver.id
      flash[:notice] = "Both users have id #{sender.id}"
    end
    
    @message = Message.new(:sender_user_id => session[:user_id], :receiver_user_id => receiver.id, :subject => params[:message][:subject], :message => params[:message][:message])
    unless @message.save
      flash[:notice] = "Error sending message."
      redirect_to :action => :send_message
      return
    end
    redirect_to :action =>:inbox
  end
  
  def read_message
    @message = Message.find(params[:id])
  end
  
end
