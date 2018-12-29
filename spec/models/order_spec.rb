require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :order_items }
    it { should have_many(:items).through(:order_items) }
  end

  describe 'class methods' do
  end

  describe 'instance methods' do
    before :each do
      user = create(:user)
      @item_1 = create(:item)
      @item_2 = create(:item)
      yesterday = 1.day.ago

      @order = create(:order, user: user, created_at: yesterday)
      @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 1, created_at: yesterday, updated_at: yesterday)
      @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 1, created_at: yesterday, updated_at: 2.hours.ago)
    end

    it '.last_udpate' do
      expect(@order.last_update).to eq(@oi_2.updated_at)
    end

    it '.total_item_count' do
      expect(@order.total_item_count).to eq(@oi_1.quantity + @oi_2.quantity)
    end

    it '.total_cost' do
      expect(@order.total_cost).to eq((@oi_1.quantity*@oi_1.price) + (@oi_2.quantity*@oi_2.price))
    end

    it '.my_item_count' do
      merchants = create_list(:merchant, 2)
      item_1 = create(:item, user: merchants[0])
      item_3 = create(:item, user: merchants[0])
      item_2 = create(:item, user: merchants[1])
      orders = create_list(:order, 3)
      create(:order_item, order: orders[0], item: item_1, price: 1, quantity: 3)
      create(:order_item, order: orders[0], item: item_3, price: 1, quantity: 7)
      create(:order_item, order: orders[1], item: item_2, price: 1, quantity: 6)
      create(:order_item, order: orders[1], item: item_3, price: 1, quantity: 2)
      create(:order_item, order: orders[2], item: item_1, price: 1, quantity: 9)

      expect(orders[0].my_item_count(merchants[0].id)).to eq(10)
      expect(orders[0].my_item_count(merchants[1].id)).to eq(0)

      expect(orders[1].my_item_count(merchants[0].id)).to eq(2)
      expect(orders[1].my_item_count(merchants[1].id)).to eq(6)

      expect(orders[2].my_item_count(merchants[0].id)).to eq(9)
      expect(orders[2].my_item_count(merchants[1].id)).to eq(0)
    end

    it '.my_revenue_value' do
      merchants = create_list(:merchant, 2)
      item_1 = create(:item, user: merchants[0])
      item_3 = create(:item, user: merchants[0])
      item_2 = create(:item, user: merchants[1])
      orders = create_list(:order, 3)
      create(:order_item, order: orders[0], item: item_1, price: 1, quantity: 3)
      create(:order_item, order: orders[0], item: item_3, price: 2, quantity: 7)
      create(:order_item, order: orders[1], item: item_2, price: 3, quantity: 6)
      create(:order_item, order: orders[1], item: item_3, price: 4, quantity: 2)
      create(:order_item, order: orders[2], item: item_1, price: 5, quantity: 9)

      expect(orders[0].my_revenue_value(merchants[0].id)).to eq(17)
      expect(orders[0].my_revenue_value(merchants[1].id)).to eq(0)

      expect(orders[1].my_revenue_value(merchants[0].id)).to eq(8)
      expect(orders[1].my_revenue_value(merchants[1].id)).to eq(18)

      expect(orders[2].my_revenue_value(merchants[0].id)).to eq(45)
      expect(orders[2].my_revenue_value(merchants[1].id)).to eq(0)
    end

    it '.my_items' do
      merchants = create_list(:merchant, 2)
      item_1 = create(:item, user: merchants[0])
      item_2 = create(:item, user: merchants[1])
      item_3 = create(:item, user: merchants[0])
      order = create(:order)
      create(:order_item, order: order, item: item_1, price: 1, quantity: 3)
      create(:order_item, order: order, item: item_2, price: 2, quantity: 7)
      create(:fulfilled_order_item, order: order, item: item_3, price: 1.50, quantity: 4)

      expect(order.my_items(merchants[0])).to eq([item_1, item_3])
      expect(order.my_items(merchants[1])).to eq([item_2])
    end

    it '.item_price' do
      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)
      order = create(:order)
      oi = create(:order_item, order: order, item: item_1, price: 345.67, quantity: 3)

      expect(order.item_price(item_1.id)).to eq(oi.price)
    end

    it '.item_quantity' do
      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)
      order = create(:order)
      oi = create(:order_item, order: order, item: item_1, price: 345.67, quantity: 397)

      expect(order.item_quantity(item_1.id)).to eq(oi.quantity)
    end

    it '.item_fulfilled?' do
      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)
      item_2 = create(:item, user: merchant)
      order = create(:order)
      oi = create(:order_item, order: order, item: item_1, price: 345.67, quantity: 397)
      oi = create(:fulfilled_order_item, order: order, item: item_2, price: 345.67, quantity: 397)

      expect(order.item_fulfilled?(item_1.id)).to eq(false)
      expect(order.item_fulfilled?(item_2.id)).to eq(true)
    end
  end
end