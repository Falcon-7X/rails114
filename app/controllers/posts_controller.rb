class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :find_group_and_post_then_check_permission, only: [:edit, :update, :destroy]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to account_posts_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to account_posts_path, alert: "Post Delete!"
  end

  def find_group_and_post_then_check_permission
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @post.group = @group
    @post.user = current_user

    if current_user != @group.user
      redirect_to root_path, alert: "You have no mission!"
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
