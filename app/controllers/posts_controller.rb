class PostsController < ApplicationController

  def new
    if params[:post]
      @post = Post.new(:user_id => session[:user_id], :name => params[:post][:name], :body => params[:post][:body])
      unless @post.save
        flash[:error] = "Could not save post"
        return
      end
      redirect_to :action => :view, :params => { :id => @post.id }
    end
  end
  
  def new_backend
    
  end

  def edit
  end

  def comment
  end

  def view
    @post = Post.find(params[:id])
  end
  
end
