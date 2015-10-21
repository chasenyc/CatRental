class SessionsController < ApplicationController

  def new
    render :sign_in
  end

  def create
    @user ||= User.find_by_credentials(user_params[:user_name], user_params[:password])
    if @user.nil?
      redirect_to new_session_url
      return
    end

    @user.reset_session_token!
    session[:session_token] = @user.session_token
    if @user.save
      redirect_to cats_url
    else
      redirect_to new_session_url
    end
  end

  def destroy
    unless current_user.nil?
      current_user.reset_session_token!
    end

    session[:session_token] = nil
    redirect_to cats_url
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
