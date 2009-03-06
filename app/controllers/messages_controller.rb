class MessagesController < ApplicationController
  
  before_filter :authorize
  
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
    @messages.each do |m|
      if m.subject.nil?
        m.subject = "(no subject)"
      end
    end
  end
  
  def send_message
    @value = params[:receiver_email]
  end
  
  def send_message_backend
    receiver = User.find(:first, :conditions => ["email=?",params[:message][:receiver_email]])
    
    if receiver.nil?
      flash[:notice] = "Could not find user #{params[:message][:receiver_email]}."
      redirect_to :action => :send_message
      return
    end
    
    if session[:user_id] == receiver.id
      flash[:notice] = "Both users have id #{receiver.id}"
      redirect_to :action => :send_message
      return
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
  
  protected 
  def authorize 
    unless User.find_by_id(session[:user_id]) 
      flash[:notice] = "Please log in" 
      redirect_to :controller => 'users', :action => 'login' 
    end 
  end
  
end
