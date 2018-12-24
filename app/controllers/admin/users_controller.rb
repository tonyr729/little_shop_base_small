class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(role: :default)
  end

  def enable
    user = User.find(params[:id])
    user.active = true
    user.save
    redirect_to admin_users_path
  end
end