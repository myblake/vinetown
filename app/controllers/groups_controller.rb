class GroupsController < ApplicationController

  def new
    if params[:group]
      @group = Group.new(:name => params[:group][:name], :description => params[:group][:description])
      unless @group.save
        flash[:error] = "Could not save group"
        return
      end
      @self = User.find(session[:user_id])
      @self.join_group(@group)
      @self.save
      @join = GroupsUsers.find(:first, :conditions => ["user_id=? and group_id=?",session[:user_id], @group.id])
      @join.admin = true
      @join.save
      redirect_to :action => :view, :params => { :id => @group.id }
    end
  end
  
  def index
    @groups = Group.find(:all)
  end
  
  def edit
    @group = Group.find(params[:id])
    if params[:group]
      @group.name = params[:group][:name]
      @group.description = params[:group][:description]
      unless @group.save
        flash[:error] = "Could not save group"
        return
      end
      redirect_to :action => :view, :params => { :id => @group.id }
    end
  end
  
  def join_group
    @self = User.find(session[:user_id])
    @group = Group.find(params[:group_id])
    @self.join_group(@group)
    @self.save
    redirect_to :action => :view, :params => {:id => @group.id}
  end
  
  def view
    @group = Group.find(params[:id])
    @posts = Post.find(:all, :conditions => ["group_id=?", params[:id]])
    @user = GroupsUsers.find(:first, :conditions => ["user_id=? and group_id=?",session[:user_id], @group.id])
    if @user
      @member = true
      @admin = GroupsUsers.find(:first, :conditions => ["user_id=? and group_id=?",session[:user_id], @group.id]).admin
      if @admin.nil? 
        @admin = false
      end
    end
  end
    
end
