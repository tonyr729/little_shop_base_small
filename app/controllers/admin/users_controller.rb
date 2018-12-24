class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(role: :default)
  end

  def show
    @user = User.find(params[:id])
    render :'profile/index'
  end
  def enable
    set_user_active(true)
  end

  def disable
    set_user_active(false)
  end

  private

  def set_user_active(state)
    user = User.find(params[:id])
    user.active = state
    user.save
    redirect_to admin_users_path
  end
end