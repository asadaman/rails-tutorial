class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :is_valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      UserMailer.send_password_reset_email(@user)
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  private

  def set_user
    @user = User.find_by(email: params[:email])
  end

  def is_valid_user
    return if @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end
end
