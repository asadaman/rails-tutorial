class UsersController < ApplicationController
  before_action :guard_for_logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :setting_for_correct_user, only: [:edit, :update]
  before_action :setting_for_admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.send_activation_email(@user)
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # before action
  def setting_for_correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def setting_for_admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
