class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.layout.per_page
  end

  def show
    @microposts = @user.microposts.order_by.paginate page: params[:page],
      per_page: Settings.layout.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".plash_updated"
      redirect_to @user
    else
      flash[:danger] = t ".plash_error_update"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = ".plash_deleted"
    else
      flash[:danger] = t ".plash_error_delete"
    end
    redirect_to users_url
  end

  def following
    @title = t ".title"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.layout.per_page
    render :show_follow
  end

  def followers
    @title = t ".title"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.layout.per_page
    render :show_follow
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".plash_danger"
    render :no_user
  end
end
