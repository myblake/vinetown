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
    if params[:comment] && params[:comment][:text]
      if params[:parent]
        parent = params[:parent]  
      else
        parent = 0
      end
      @comment = Comment.new(:user_id => session[:user_id], :text => params[:comment][:text], :parent_id => parent, :post_id => params[:post][:id] )
      unless @comment.save
        flash[:error] = "Could not save comment"
        return
      end
      redirect_to :action => :view, :params => { :id => @post_id }
    else
      if params[:comment] && params[:comment][:parent]
        @parent_id = params[:comment][:parent]  
      end
    end
  end

  def view
    @post = Post.find(params[:id])
    @comments_array = Comment.find(:all, :conditions => ["post_id=?", params[:id]], :order => "id ASC")
    @comments = {}
    @comments["0"] = []
    for comment in @comments_array
      if comment.parent_id == 0
        @comments["0"].push(comment)
        @comments[comment.id] = Array.new
      else
        @comments[comment.parent_id].push(comment)
        @comments[comment.id] = Array.new
      end
    end
  end
  
end
