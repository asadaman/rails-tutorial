class SessionsController < ApplicationController
  MESSAGE = "Account not activated.Check your email for the activation link.".freeze

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      check_activation_and_log_in(user)
    else
      flash.now[:danger] = 'invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to(root_url)
  end

  private

  def should_remember_user?
    params[:session][:remember_me] == '1'
  end

  def check_activation_and_log_in(user)
    if user.activated?
      log_in(user)
      should_remember_user? ? remember(user) : forget(user)
      redirect_back_or(user)
    else
      # message = "Account not activated."
      # message += "Check your email for the activation link."
      # flash[:warning] = message
      flash[:warning] = MESSAGE
      redirect_to(root_url)
    end
  end
end
