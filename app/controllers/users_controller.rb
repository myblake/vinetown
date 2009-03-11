require 'digest/sha1'

class UsersController < ApplicationController

  before_filter :authorize, :except => [:index, :login, :login_backend, :signup, :signup_backend, :forgot_password, :create_welcome, :create_forgot_password, :confirm]

  def signup
    if session[:user_id]
      #redirect_to :controller => "sleeps"
    end
	end
	
	def signup_backend
	  sha_passwd = Digest::SHA1.hexdigest(params[:user][:password]) 
		@user = User.new(:email => params[:user][:email],
		                :password => sha_passwd,
		                :first_name => params[:user][:first_name],
		                :last_name => params[:user][:last_name],
		                :confirmation => Digest::SHA1.hexdigest(params[:user][:email] + Time.now.to_s),
		                :confirmed => false,
		                :pw_reset => false)
	  if params[:user][:password] != params[:user][:password_confirm]
	    flash[:notice] = "Passwords don't match."
			redirect_to :action => :signup
      return
		end
		if @user.save
      redirect_to :action => :create_welcome, :params => { :email => @user.email }
		else
			redirect_to :action => :signup
		end
	end
  
  def login
    if session[:user_id]
      redirect_to :action => :index
    end
  end
  
	def login_backend
		email = params[:user][:email]
		password = Digest::SHA1.hexdigest(params[:user][:password])
		user = User.find (:first, :conditions => ["email=? and password=?", email, password])
		if user
      if !user.confirmed
        flash[:notice] = "Please confirm your email address."
        redirect_to :action => :index
        return
      end      
			session[:user_id] = user.id
      session[:user_email] = user.email
      user.last_login_at = Time.now
      unless user.save
        #flash something on the backend maybe? this probably means a validation failed, why?
      end
      if user.pw_reset
        redirect_to :action => :password_reset
        return
      end
      redirect_to :controller => :users, :action => :index
		else
			unless email=~/.*\@.*\..*/
  			flash[:notice] = "Incorrect email or password. Your email address appears misformatted."
			else
			  flash[:notice] = "Incorrect email or password."
		  end
			redirect_to :controller => :users, :action => :login
		end
	end
	
	def logout
		session[:user_id] = nil
		session[:user_email] = nil
		flash[:notice] = "You are now logged out."
		redirect_to :controller => :users, :action => :index
	end
	
  def index
    redirect_to :controller => :home, :action => :index
  end
  
  def profile
    unless @user = User.find(params[:id])
      flash[:notice] = "Couldn't not find user"
      redirect_to :action => :index
    end
    @friends = Friend.find(:first, :conditions => ["(user_id_1=? and user_id_2=?) or (user_id_1=? and user_id_2=?)", session[:user_id], @user.id, @user.id, session[:user_id]])
  end

  def edit_profile
    @user = User.find(session[:user_id])
    if params[:user]
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
      
      if params[:user][:password] != ""      
        if params[:user][:password] != params[:user][:password_confirm]
    	    flash[:notice] = "Passwords don't match"
    			redirect_to :action => :edit_profile
          return
    		end
    	  @user.password = Digest::SHA1.hexdigest(params[:user][:password])
    	end
      if @user.save
        flash[:notice] = "Your settings are updated!"
        redirect_to :action => :profile, :params => {:id => session[:user_id]}
      else
        flash[:notice] = "Error saving new settings."
        redirect_to :action => :edit_profile
      end               
    end
  end
  
  def edit_profile_2
    @user = User.find(session[:user_id])
    if params[:user]      
      dob = Time.parse(params[:user][:date_of_birth])
  		@user.date_of_birth = dob
  		@user.gender  = params[:user][:gender]
  		@user.hometown  = params[:user][:hometown]
  		@user.state  = params[:user][:state]
  		@user.country = params[:user][:country]
  		@user.status = params[:user][:status]
      @user.interests = params[:user][:interests]
      @user.favorite_wines = params[:user][:favorite_wines]
    	@user.favorite_food_and_wine_pairings = params[:user][:favorite_food_and_wine_pairings]
      if @user.save
        flash[:notice] = "Your settings are updated!"
        redirect_to :action => :profile, :params => {:id => session[:user_id]}
      else
        redirect_to :action => :edit_profile_2
      end 
    end
  end
  
  
  def create_welcome
    user = User.find(:first, :conditions => ["email=?", params[:email]])
    if UserMailer.deliver_welcome(user)
      flash[:notice] = "A confirmation email has been sent to the address you provided."
    else
      flash[:notice] = "We have experienced an issue with our mail servers. Please contact vinetown@vinetown.com for more assistance."
    end
    redirect_to :action => :index
  end
  
  def view_email
    #user = User.find(:first, :conditions => ["email=?", params[:email]])
    #email = UserMailer.create_welcome(user)
    #render ( :text => "<pre>" + email.encoded + "</pre>" )
  end
  
  def forgot_password
    
  end
  
  def password_reset
    @user = User.find(session[:user_id])
    if params[:user]
      if params[:user][:password] != params[:user][:password_confirm]
  	    flash[:notice] = "Passwords don't match"
        return
  		end
  	  @user.password = Digest::SHA1.hexdigest(params[:user][:password])
  	  @user.pw_reset = false
  	  if @user.save
        flash[:notice] = "Your settings are updated!"
        redirect_to :controller => :users, :action => :index
      else
        flash[:notice] = "Error saving new settings."
      end
    end
  end
  
  def create_forgot_password
    if session[:user_id]
      redirect_to :action => :index
      return
    end
    user = User.find(:first, :conditions => ["email=?", params[:user][:email]])
    if user
      if user.pw_reset
        flash[:notice] = "Password has been recently reset, please check you inbox"
        redirect_to :action => :login
        return
      end
      password = Digest::SHA1.hexdigest(Time.now.to_s).to_s[0..7]
  	  sha_passwd = Digest::SHA1.hexdigest(password) 
  	  user.password = sha_passwd
  	  user.pw_reset = true
  	  user.save
      if UserMailer.deliver_forgot_password(user, password)
        flash[:notice] = "Please check your email for a new password."
      end
    else
      flash[:notice] = "Could not find user account for email address #{params[:email]}"
    end
    redirect_to :action => :index
  end
  
  def search
    if params[:search]
      query = params[:search][:query]
      unless query.empty?
        if m = query.match(/(\w*)\s(\w*)/)
          @results = User.find(:all, :conditions => ["first_name like ? and last_name like ?", "#{m[1]}%", "#{m[2]}%"])
        elsif m = query.match(/(\w*)/)
          @results = User.find(:all, :conditions => ["first_name like ? or last_name like ?", "#{m[1]}%", "#{m[1]}%"])
        end
      else
        @results = User.find(:all)  
      end
    end
  end
  
  # confirms user, link is emailed to user to confirm validity and ownership of email address
  # may want to change where we redirect to
  def confirm
    @user = User.find(:first, :conditions => ["confirmation=?", params[:a]])
    unless @user 
      flash[:error] = "Invalid User Confirmation link"
      redirect_to :action => :index
      return
    end
    if @user.confirmed
      flash[:notice] = "User was previously confirmed"
      redirect_to :action => :index
      return
    end
    @user.confirmed = true
    session[:user_id] = @user.id
    session[:user_email] = @user.email
    @user.last_login_at = Time.now
    unless @user.save
      #flash something on the backend maybe? this probably means a validation failed, why?
    end
    flash[:notice] = "User confirmed. Please fill out your user profile."
    redirect_to :action => :edit_profile_2
  end
  
  protected 
  def authorize 
    unless User.find_by_id(session[:user_id]) 
      flash[:notice] = "Please log in" 
      redirect_to :controller => 'users', :action => 'login' 
    end 
  end
  
end
