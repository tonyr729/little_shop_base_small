class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find(params[:id])
    if @merchant.default?
      redirect_to admin_user_path(@merchant)
    else
      render :'merchants/show'
    end
  end

  def enable
    set_user_active(true)
  end

  def disable
    set_user_active(false)
  end

  def downgrade
    set_user_role(User.find(params[:id]), :default)
    redirect_to merchants_path
  end

  private

  def set_user_active(state)
    user = User.find(params[:id])
    user.active = state
    user.save
    redirect_to merchants_path
  end
end