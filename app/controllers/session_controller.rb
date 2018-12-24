class SessionController < ApplicationController
  def new
    if current_user
      flash[:info] = 'You are already logged in'
      redirect_user(current_user)
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'You are logged in'
      redirect_user(user)
    else
      flash[:error] = 'Email or password is incorrect'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = 'You are logged out'
    redirect_to root_path
  end

  private

  def redirect_user(user)
    if user.default?
      redirect_to profile_path
    elsif user.merchant?
      redirect_to dashboard_path
    elsif user.admin?
      redirect_to admin_dashboard_index_path
    end
  end
end