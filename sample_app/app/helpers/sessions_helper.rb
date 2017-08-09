module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def user_on_session?
    user_id = session[:user_id]
  end

  def user_on_cookies?
    user_id = cookies.signed[:user_id]
  end

  def current_user
    if (user_id = user_on_session?)
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = user_on_cookies? &&
             user = User.find_by(id: user_id) &&
             user.authenticated?(cookies[:remember_token]))
      log_in user
      @current_user = user
    end
  end

  def logged_in?
    current_user.present?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
