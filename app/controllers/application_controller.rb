class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    token = session[:session_token]
    @user = User.find_by_token(token)
  end



end
