class GroupsController < ApplicationController
before_action :authenticate_user! , only: [:new, :create, :edit, :updete, :destroy]
before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success!"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, alert: "Group deleted!"
  end

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "You have no mission!"
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page =>3)
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "Join Success!"
    else
      flash[:warning] = "You has already joined!"
    end
    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "Quit Success."
    else
      flash[:warning] = "Can not quit!"
    end
    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
