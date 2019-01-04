class Dashboard::ItemsController < Dashboard::BaseController
  def index
    merchant = current_user
    @items = merchant.items.order(:name)
  end

  def new
    @item = Item.new
    @form_path = [:dashboard, @item]
  end

  def edit
    @item = Item.find_by(slug: params[:slug])
    @form_path = [:dashboard, @item]
  end

  def create
    ip = item_params
    if ip[:image].empty?
      ip[:image] = 'https://picsum.photos/200/300/?image=524'
    end
    ip[:active] = true
    @merchant = current_user
    if current_admin?
      @merchant = User.find_by(slug: params[:merchant_id])
    end
    @item = @merchant.items.create(ip)
    @item.generate_slug
    if @item.save
      flash[:success] = "#{@item.name} has been added!"
      if current_admin?
        redirect_to admin_merchant_items_path(@merchant)
      else
        redirect_to dashboard_items_path
      end
    else
      if current_admin?
        @form_path = [:admin, @merchant, @item]
      else
        @form_path = [:dashboard, @item]
      end
      render :new
    end
  end

  def destroy
    @item = Item.find_by(slug: params[:slug])
    merchant = @item.user
    if @item && @item.ever_ordered?
      flash[:error] = "Attempt to delete #{@item.name} was thwarted!"
    elsif @item
      @item.destroy
    end
    if current_admin?
      redirect_to admin_merchant_items_path(merchant)
    else
      redirect_to dashboard_items_path
    end
  end
  
  def update
    @merchant = current_user
    if current_admin?
      @merchant = User.find_by(slug: params[:merchant_id])
    end
    
    @item = Item.find_by(slug: params[:slug])

    ip = item_params
    if ip[:image].empty?
      ip[:image] = 'https://picsum.photos/200/300/?image=524'
    end
    ip[:active] = true
    if ip[:name] != @item.name && ip[:name] != ""
      @item.update(ip)
      @item.generate_slug
    else
      @item.update(ip)
    end
    if @item.save
      flash[:success] = "#{@item.name} has been updated!"
      if current_admin?
        redirect_to admin_merchant_items_path(@merchant)
      else
        redirect_to dashboard_items_path
      end
    else
      if current_admin?
        @form_path = [:admin, @merchant, @item]
      else
        @form_path = [:dashboard, @item]
      end
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
    item = Item.find_by(slug: params[:slug])
    item.active = state
    item.save
    if current_admin?
      redirect_to admin_merchant_items_path(item.user)
    else
      redirect_to dashboard_items_path
    end
  end

end