class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.default?
        redirect_to profile_path
      elsif user.merchant?
        redirect_to dashboard_path
      elsif user.admin?
        redirect_to admin_dashboard_index_path
      end
    else
      flash[:error] = 'Email or password is incorrect'
      render :new
    end
  end

  def destroy
    redirect_to root_path
  end
end