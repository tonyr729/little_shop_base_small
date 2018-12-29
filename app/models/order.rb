class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  enum status: [:pending, :completed, :cancelled]

  def last_update
    order_items.maximum(:updated_at)
  end

  def total_item_count
    order_items.sum(:quantity)
  end

  def total_cost
    oi = order_items.pluck("sum(quantity*price)")
    oi.sum
  end

  def my_item_count(merchant_id)
    self.order_items
      .joins(:item)
      .where("items.merchant_id=?", merchant_id)
      .pluck("sum(order_items.quantity)")
      .first.to_i
  end

  def my_revenue_value(merchant_id)
    self.order_items
      .joins(:item)
      .where("items.merchant_id=?", merchant_id)
      .pluck("sum(order_items.quantity * order_items.price)")
      .first.to_i
  end

  def my_items(merchant_id)
    Item.joins(order_items: :order)
      .where(
        :merchant_id => merchant_id,
        :"orders.id" => self.id,
        :"orders.status" => :pending,
        :"order_items.fulfilled" => false
      )
  end

  def item_price(item_id)
    order_items.where(item_id: item_id).pluck(:price).first
  end

  def item_quantity(item_id)
    order_items.where(item_id: item_id).pluck(:quantity).first
  end
end