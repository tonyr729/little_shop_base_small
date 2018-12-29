class Dashboard::ItemsController < Dashboard::BaseController
  def index
    merchant = current_user
    @items = merchant.items.order(:name)
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
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

  def destroy
    @item = Item.find(params[:id])
    if @item && @item.ever_ordered?
      flash[:error] = "Attempt to delete #{@item.name} was thwarted!"
    elsif @item
      @item.destroy
    end
    redirect_to dashboard_items_path
  end

  def update
    @item = Item.find(params[:id])

    ip = item_params
    if ip[:image].empty?
      ip[:image] = 'https://picsum.photos/200/300/?image=524'
    end
    ip[:active] = true
    @item.update(ip)
    if @item.save
      flash[:success] = "#{@item.name} has been updated!"
      redirect_to dashboard_items_path
    else
      render :edit
    end
  end

  def enable
    set_item_active(true)
  end

  def disable
    set_item_active(false)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :image, :price, :inventory)
  end

  def set_item_active(state)
    item = Item.find(params[:id])
    item.active = state
    item.save
    redirect_to dashboard_items_path
  end

end