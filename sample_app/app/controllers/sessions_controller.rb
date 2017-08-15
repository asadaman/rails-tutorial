class SessionsController < ApplicationController
  def new
  end

  def should_remember_user?
    params[:session][:remember_me] == '1'
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      should_remember_user? ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
