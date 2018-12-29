class Dashboard::ItemsController < ApplicationController
  before_action :restrict_access

  def index
    merchant = current_user
    @items = merchant.items.order(:name)
  end

  def new
    @item = Item.new
  end

  def create
    ip = item_params
    if ip[:image].empty?
      ip[:image] = 'https://picsum.photos/200/300/?image=524'
    end
    ip[:active] = true
    @item = current_user.items.create(ip)
    if @item.save
      flash[:success] = "#{@item.name} has been added!"
      redirect_to dashboard_items_path
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :image, :price, :inventory)
  end

  def restrict_access
    render file: 'errors/not_found', status: 404 unless current_user && (current_merchant? || current_admin?)
  end
end