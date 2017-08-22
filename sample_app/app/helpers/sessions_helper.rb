module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def user_id_from_cookie_or_session
    session[:user_id] || cookies.signed[:user_id]
  end

  def user_on_session?
    session[:user_id].present?
  end

  def user_on_cookies?
    cookies.signed[:user_id].present?
  end

  def user
    user = User.find_by(id: user_id_from_cookie_or_session)
    return user if user_on_session?
    if user_on_cookies? && user.authenticated?(:remember, cookies[:remember_token])
      log_in(user)
      user
    end
  end

  def current_user
    return if user_id_from_cookie_or_session.blank?
    user
  end

  def set_current_user
    @current_user = current_user
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
    forget(set_current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
