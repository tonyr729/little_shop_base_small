class ProfileController < ApplicationController
  before_action :require_default_user, only: :index

  def index
    @user = current_user
  end

  private

  def require_default_user
    render file: 'errors/not_found', status: 404 unless current_user && current_user.default?
  end
end