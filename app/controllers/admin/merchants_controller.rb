class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find(params[:id])
    render :'merchants/show'
  end

  def enable
    set_user_active(true)
  end

  private

  def set_user_active(state)
    user = User.find(params[:id])
    user.active = state
    user.save
    redirect_to merchants_path
  end
end