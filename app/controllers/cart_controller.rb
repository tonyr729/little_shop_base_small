class CartController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :require_default_user_or_visitor

  def index
    @items = @cart.items
  end

  def add_item
    item = Item.find(params[:id])
    @cart.add_item(item.id)
    flash[:success] = "You have #{pluralize(@cart.count_of(item.id), 'package')} of #{item.name} in your cart"
    session[:cart] = @cart.contents
    redirect_to items_path
  end

  private

  def require_default_user_or_visitor
    render file: 'errors/not_found', status: 404 unless !current_user || (current_user && current_user.default?)
  end

end