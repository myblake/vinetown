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
                        :group_id => params[:post][:group_id])
      unless @post.save
        flash[:error] = "Could not save post"
        return
      end
      redirect_to :action => :view, :params => { :id => @post.id }
    end
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
      if params[:post][:group] == '1'
        @post.group_id = params[:post][:group_id]
      else
        @post.group_id = 0
      end
      #asdf
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
      @foreign_id = params[:post][:id]      
    end
    if params[:status]
      @foreign_id = params[:status][:id]
    end
    if params[:comment] && params[:comment][:text]
      if params[:parent]
        parent = params[:parent]  
      else
        parent = 0
      end
      @comment = Comment.new(:user_id => session[:user_id], :text => params[:comment][:text], :parent_id => parent, :foreign_id => @foreign_id)
      if params[:post]      
        @comment.type = "Post"
      end
      if params[:status]
        @comment.type = "Status"
      end  
      unless @comment.save
        flash[:error] = "Could not save comment"
        return
      end
      if params[:post]
        redirect_to :action => :view, :params => { :id => @foreign_id }
      end
      if params[:status]
        redirect_to :controller => :home, :action => :neighborhood
      end
    else
      if params[:comment] && params[:comment][:parent]
        @parent_id = params[:comment][:parent]  
      end
    end
  end
  
  def diary
    @groupusers = GroupsUsers.find(:all, :conditions => ["user_id=?", session[:user_id]])    
    @groups = {}
    for group_id in @groupusers
      group = Group.find(:first, :conditions => ["id=?", group_id.group_id])
      @groups[group.name] = group.id
    end
    if params[:diary]
      #diary has the params => who    what    when    where    with    thoughts
      @post = Post.new( :user_id => session[:user_id],
                        :name => "#{params[:diary][:what]} #{params[:diary][:when]}", 
                        :body => "Wine: #{params[:diary][:what]}\n\nWhen: #{params[:diary][:when]}\n\nWhere: #{params[:diary][:where]}\n\nWith: #{params[:diary][:who]}\n\nPaired with: #{params[:diary][:with]}\n\nAdditional thoughts: #{params[:diary][:thoughts]}",
                        :news => 0,
                        :home_page => params[:diary][:home_page],
                        :group_id => params[:post][:group_id])
      unless @post.save
        flash[:error] = "Could not save post"
        return
      end
      redirect_to :action => :view, :params => { :id => @post.id }
    end
  end

  # view for a post
  # has to build the object for nested comments
  def view
    @post = Post.find(params[:id])
    # sanitizes html
    @post.name = @post.name.gsub(/<\/?\w+((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)\/?>/, "")
    if @post.body
      # sanitizes html and reformats newlines into html line breaks
      @post.body = @post.body.gsub(/<\/?\w+((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)\/?>/, "")
      @post.body = @post.body.gsub("\n", "<br />")
    end
    if session[:user_id]
      @edit = (@post.user.id == session[:user_id])
      @show_comment = true
    else 
      @edit = false
      return
    end
    
    # pull all comments and then create nested arrays using the id of the parent comment as the array index
    @comments_array = Comment.find(:all, :conditions => ["type=\"Post\" and foreign_id=?", params[:id]], :order => "id ASC")
    @comments = {}
    @comments["0"] = []
    for comment in @comments_array
      if comment.parent_id.to_i == 0
        @comments["0"].push(comment)
        @comments[comment.id] = Array.new
      else
        @comments[comment.parent_id.to_i].push(comment)
        @comments[comment.id] = Array.new
      end
    end
  end
  
end
