class HomeController < ApplicationController
  def about
    @about = AboutUs.find(:first)
    @about.text = @about.text.gsub("\n", "<br />")
    if @about.nil?
      @about = AboutUs.new(:text=>"Please edit")
      @about.save
    end
  end
  
  #
  # Will also need to show friends comments on these things.
  #
  def neighborhood
    @user = User.find(session[:user_id])
    if params[:status]
      @status = Status.new(:status => params[:status][:status], :user_id => session[:user_id])
      @status.save
    else
      @status = Status.find(:last, :conditions => ["user_id=?", session[:user_id]])
    end
    @posts = Post.find(:all, :conditions => ["user_id in (select user_id_1 from friends where user_id_2=#{session[:user_id]} and accepted=1) or user_id in (select user_id_2 from friends where user_id_1=#{session[:user_id]} and accepted=1)"], :order => "created_at DESC")
    @statuses = Status.find(:all, :conditions => ["user_id in (select user_id_1 from friends where user_id_2=#{session[:user_id]} and accepted=1) or user_id in (select user_id_2 from friends where user_id_1=#{session[:user_id]} and accepted=1)"], :order => "created_at DESC")
    @comments = []
    for status in @statuses
      @mycomments = Comment.find(:all, :conditions => ["type=\"Status\" and foreign_id=?", status.id], :order => "id ASC")
      @comments[status.id] = @mycomments
    end

    # pull all comments and then create nested arrays using the id of the parent comment as the array index
  end
  
  def index
    #pull in posts
    @posts = Post.find(:all, :conditions => ["home_page = 1"], :order => "created_at DESC")
    @news = Post.find(:all, :conditions => ["news = 1"], :order => "created_at DESC")
  end
  
  def community
    unless session[:user_id]
      redirect_to :action => :index
    end
    @posts = Post.find(:all, :conditions => ["community_page = 1"], :order => "created_at DESC")
  end
  
  def edit_about_us
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :action => :index
    end
    @about = AboutUs.find(:first)
  end
  
  def edit_about_us_backend
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :action => :index
    end
    @about = AboutUs.find(:first)
    @about.text = params[:about][:text]
    if @about.save
      redirect_to :action => :about
    else
      redirect_to :action => :edit_about_us
    end
  end
end
