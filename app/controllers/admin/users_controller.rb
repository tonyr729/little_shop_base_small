class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(role: :default)
  end
end