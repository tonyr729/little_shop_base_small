class Admin::BaseController < ApplicationController
  before_action :require_admin

  def require_admin
    render file: 'errors/not_found', status: 404 unless current_user && current_admin?
  end

  def set_user_role(user, role)
    user.role = role
    user.save
  end

end