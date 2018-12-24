class MerchantsController < ApplicationController
  before_action :require_merchant, only: :show

  def index
    flags = {role: :merchant}
    unless current_admin?
      flags[:active] = true
    end
    @merchants = User.where(flags)
  end

  def show
    @merchant = current_user
  end

  private

  def require_merchant
    render file: 'errors/not_found', status: 404 unless current_user && current_user.merchant?
  end
end