class MerchantsController < ApplicationController
  before_action :require_merchant, only: :show

  def show
  end

  private

  def require_merchant
    render file: 'errors/not_found', status: 404 unless current_user && current_user.merchant?
  end
end