class CartController < ApplicationController
  before_action :require_default_user

  def index
  end

  private

  def require_default_user
    render file: 'errors/not_found', status: 404 unless current_user && current_user.default?
  end

end