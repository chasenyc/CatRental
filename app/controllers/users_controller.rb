class UsersController < ApplicationController

  def new
    # @user = User.find(params[:id])
    render :new
  end

  def create
    @user = User.new
    @user.user_name = user_params[:user_name]
    @user.password = params[:password]
    @user.reset_session_token!
    session[:session_token] = @user.session_token
    if @user.save
      redirect_to cats_url
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password_digest)
  end

end
