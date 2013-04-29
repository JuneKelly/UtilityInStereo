module SessionsHelper

  def login(user)
    session[:user_id] = user.id
    user.last_login = Time.now.utc
    user.save
  end

  def logout
    session[:user_id] = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_path, notice: "Please sign in."
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user == user
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def stored_location
    return session[:return_to]
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_location
  end

  def clear_location
    session.delete(:return_to)
  end

end
