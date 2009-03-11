class HomeController < ApplicationController
  def about
    @about = AboutUs.find(:first)
    if @about.nil?
      @about = AboutUs.new(:text=>"Please edit")
      @about.save
    end
  end
  
  def index
    #pull in posts
    @posts = Post.find(:all, :conditions => ["home_page = 1"])
    @news = Post.find(:all, :conditions => ["news = 1"])
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
