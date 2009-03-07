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
    if params[:post]
      @post_id = params[:post][:id]
    end
    if params[:comment][:text]
      if params[:comment][:parent]
        parent = params[:comment][:parent]  
      else
        parent = 'NULL'
      end
      @comment = Comment.new(:user_id => session[:user_id], :text => params[:comment][:text], :parent_id => parent, :post_id => params[:post][:id] )
      unless @comment.save
        flash[:error] = "Could not save comment"
        return
      end
      redirect_to :action => :view, :params => { :id => @post_id }
    end
  end

  def view
    @post = Post.find(params[:id])
    @comments = Comment.find(:all, :conditions => ["post_id=?", params[:id]], :order => "id")

  end
  
end
