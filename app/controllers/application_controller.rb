class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    token = session[:session_token]
    return nil if self.session[:session_token].nil?
    @user ||= User.find_by_token(token)
  end

  def login_user!(user)
    user.reset_session_token!
    self.session[:session_token] = user.session_token
  end

  def user_signed_in
    redirect_to cats_url unless current_user.nil?
  end



end
