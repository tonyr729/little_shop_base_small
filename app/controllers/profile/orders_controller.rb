class Profile::OrdersController < ApplicationController
  before_action :require_default_user, only: :index

  def index
    @orders = current_user.orders
  end

  def create
    order = Order.create(user: current_user, status: :pending)
    @cart.items.each do |item|
      order.order_items.create!(
        item: item,
        price: item.price,
        quantity: @cart.count_of(item.id),
        fulfilled: false)
    end
    session[:cart] = nil
    @cart = Cart.new({})
    flash[:success] = "You have successfully checked out!"

    redirect_to profile_path
  end

  private

  def require_default_user
    render file: 'errors/not_found', status: 404 unless current_user && current_user.default?
  end
end