require 'digest/sha1'

class UsersController < ApplicationController

  before_filter :authorize, :except => [:login, :signup, :signup_backend, :login_backend]

  def signup
    if session[:user_id]
      #redirect_to :controller => "sleeps"
    end
	end
	
	def signup_backend
	  sha_passwd = Digest::SHA1.hexdigest(params[:user][:password]) 
		@user = User.new(:username => params[:user][:username],
		                :email => params[:user][:email],
		                :password => sha_passwd,
		                :first_name => params[:user][:first_name],
		                :last_name => params[:user][:last_name],
		                :last_login_at => Time.now)
	  if params[:user][:password] != params[:user][:password_confirm]
	    flash[:notice] = "Passwords don't match."
			redirect_to :action => :signup
      return
		end
		if @user.save
			redirect_to :action => :login_backend, :user => {:username => params[:user][:username], :password => params[:user][:password]}
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
		username = params[:user][:username]
		password = Digest::SHA1.hexdigest(params[:user][:password])
		user = User.find (:first, :conditions => ["username=? and password=?", username, password])
		if user
			session[:user_id] = user.id
      session[:user_username] = user.username
      user.last_login_at = Time.now
      unless user.save
        #flash something on the backend maybe? this probably means a validation failed, why?
      end
			redirect_to :controller => "users", :action => :index
		else
			flash[:notice] = "Incorrect username or password."
			redirect_to :controller => "users", :action => :login
		end
	end
	
	def logout
		session[:user_id] = nil
		session[:user_username] = nil
		flash[:notice] = "You are now logged out."
		redirect_to :controller => "users", :action => :index
	end
	
  def index
  end
  
  def profile
    @user = User.find(params[:id])
  end

  def edit_profile
    @user = User.find(session[:user_id])
    if params[:user]
      @user.email = params[:user][:email]
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
      
      if params[:user][:password] != ""      
        if params[:user][:password] != params[:user][:password_confirm]
    	    flash[:error] = "Passwords don't match"
    			redirect_to :action => :edit_profile
          return
    		end
    	  @user.password = Digest::SHA1.hexdigest(params[:user][:password])
    	end
      if @user.save
        flash[:notice] = "Your settings are updated!"
        redirect_to :action => :profile, :params => {:id => session[:user_id]}
      else
        redirect_to :action => :edit_profile
      end               
    end
  end
  
end
