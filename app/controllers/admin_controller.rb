class AdminController < ApplicationController
  before_filter :authorize

  def index
    @users = User.find(:all)
    @size = @users.length
    @active_users_today = 0 
    for user in @users
      if (user.last_login_at && Time.now - user.last_login_at < 86400)
        @active_users_today += 1
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
    if params[:user]
      @user.admin = params[:user][:admin]
      @user.save
    end
  end

  def update_comments
    comments = Comment.find(:all)
    for comment in comments
      comment.foreign_id = comment.post_id
      comment.type = "Post"    
      comment.save
    end
  end
  
  protected
  def authorize 
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :controller => :home
    end 
  end
end
