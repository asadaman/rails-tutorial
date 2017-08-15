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
    session[:user_id].present?
  end

  def user_on_cookies?
    cookies.signed[:user_id].present?
  end

  def find_current_user_by_using_cookies(user_id)
    user = User.find_by(id: user_id)
    if user.authenticated?(cookies[:remember_token])
      log_in user
      user
    end
  end

  def current_user
    if user_on_session?
      user_id = session[:user_id]
      user ||= User.find_by(id: user_id)
    elsif user_on_cookies?
      user_id = cookies.signed[:user_id]
      user = find_current_user_by_using_cookies(user_id)
    end
  end

  def logged_in?
    @current_user = current_user if current_user.present?
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
