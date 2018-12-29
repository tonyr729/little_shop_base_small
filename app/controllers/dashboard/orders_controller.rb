class Dashboard::OrdersController < Dashboard::BaseController
  def show
    @order = Order.find(params[:id])
    @items = @order.my_items(current_user)
  end
end