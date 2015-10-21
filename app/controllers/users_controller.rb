class UsersController < ApplicationController

  before_action :user_signed_in, only: [:new, :create]

  def new
    # @user = User.find(params[:id])
    render :new
  end

  def create
    @user = User.new(user_params)
    login_user!(@user)
    if @user.save
      redirect_to cats_url
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
