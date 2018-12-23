class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id
    flash[:success] = 'You are registered and logged in'
    redirect_to profile_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :city, :state, :zip)
  end
end