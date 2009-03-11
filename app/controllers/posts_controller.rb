class PostsController < ApplicationController

  # delete posts
  
  def index
    @posts = Post.find(:all, :conditions => ["user_id=?", session[:user_id]])
  end

  def new
    @groupusers = GroupsUsers.find(:all, :conditions => ["user_id=?", session[:user_id]])    
    @groups = {}
    for group_id in @groupusers
      group = Group.find(:first, :conditions => ["id=?", group_id.group_id])
      @groups[group.name] = group.id
    end
    if params[:post]
      @post = Post.new( :user_id => session[:user_id],
                        :name => params[:post][:name], 
                        :body => params[:post][:body],
                        :news => params[:post][:news],
                        :home_page => params[:post][:home_page],
                        :community_page => params[:post][:community_page],
                        :group_id => params[:post][:group_id])
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
    @post = Post.find(params[:id])
    @groupusers = GroupsUsers.find(:all, :conditions => ["user_id=?", session[:user_id]])    
    @groups = {}
    for group_id in @groupusers
      group = Group.find(:first, :conditions => ["id=?", group_id.group_id])
      @groups[group.name] = group.id
    end
    if params[:post]
      @post.name = params[:post][:name]
      @post.body = params[:post][:body]
      @post.news = params[:post][:news]
      @post.home_page = params[:post][:home_page]
      @post.community_page = params[:post][:community_page]
      if params[:post][:group] == 1
        @post.group_id = params[:post][:group_id]
      else
        @post.group_id = 0
      end
      if @post.save
        flash[:notice] = "Post Updated"
        redirect_to :action => :view, :params => {:id => @post.id}
      else
        flash[:notice] = "Error saving post."
        redirect_to :action => :edit
      end
    end
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
    @edit = (@post.user.id == session[:user_id])
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
