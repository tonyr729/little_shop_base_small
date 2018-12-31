require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Profile Orders page', type: :feature do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, user: @merchant_1)
    @item_2 = create(:item, user: @merchant_2)
  end
  context 'as a registered user' do
    it 'should show a message when I have no orders' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_orders_path

      expect(page).to have_content('You have no orders yet')
    end
    it 'should show information about each order when I do have orders' do
      user = create(:user)
      yesterday = 1.day.ago

      @order = create(:order, user: user, created_at: yesterday)
      @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 1, created_at: yesterday, updated_at: yesterday)
      @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 1, created_at: yesterday, updated_at: 2.hours.ago)

      user.reload
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_orders_path
      expect(page).to_not have_content('You have no orders yet')

      within "#order-#{@order.id}" do
        expect(page).to have_link("Order ID #{@order.id}")
        expect(page).to have_content("Created: #{@order.created_at}")
        expect(page).to have_content("Last Update: #{@order.last_update}")
        expect(page).to have_content("Status: #{@order.status}")
        expect(page).to have_content("Item Count: #{@order.total_item_count}")
        expect(page).to have_content("Total Cost: #{@order.total_cost}")
      end
    end
    it 'should show a single order show page' do
      user = create(:user)
      yesterday = 1.day.ago

      @order = create(:order, user: user, created_at: yesterday)
      @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 3, created_at: yesterday, updated_at: yesterday)
      @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 5, created_at: yesterday, updated_at: 2.hours.ago)

      user.reload
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_order_path(@order)

      expect(page).to have_content("Order ID #{@order.id}")
      expect(page).to have_content("Created: #{@order.created_at}")
      expect(page).to have_content("Last Update: #{@order.last_update}")
      expect(page).to have_content("Status: #{@order.status}")
      within "#oitem-#{@oi_1.id}" do
        expect(page).to have_content(@oi_1.item.name)
        expect(page).to have_content(@oi_1.item.description)
        expect(page.find("#item-#{@oi_1.item.id}-image")['src']).to have_content(@oi_1.item.image)
        expect(page).to have_content("Merchant: #{@oi_1.item.user.name}")
        expect(page).to have_content("Price: #{number_to_currency(@oi_1.price)}")
        expect(page).to have_content("Quantity: #{@oi_1.quantity}")
        expect(page).to have_content("Subtotal: #{number_to_currency(@oi_1.price*@oi_1.quantity)}")
        expect(page).to have_content("Subtotal: #{number_to_currency(@oi_1.price*@oi_1.quantity)}")
        expect(page).to have_content("Fulfilled: No")
      end
      within "#oitem-#{@oi_2.id}" do
        expect(page).to have_content(@oi_2.item.name)
        expect(page).to have_content(@oi_2.item.description)
        expect(page.find("#item-#{@oi_2.item.id}-image")['src']).to have_content(@oi_2.item.image)
        expect(page).to have_content("Merchant: #{@oi_2.item.user.name}")
        expect(page).to have_content("Price: #{number_to_currency(@oi_2.price)}")
        expect(page).to have_content("Quantity: #{@oi_2.quantity}")
        expect(page).to have_content("Subtotal: #{number_to_currency(@oi_2.price*@oi_2.quantity)}")
        expect(page).to have_content("Fulfilled: Yes")
      end
      expect(page).to have_content("Item Count: #{@order.total_item_count}")
      expect(page).to have_content("Total Cost: #{@order.total_cost}")
    end
    it 'allows me to cancel an order that is not yet complete' do
      user = create(:user)
      merchant = create(:merchant)
      item = create(:item, inventory: 100)

      order_1 = create(:completed_order, user: user)
      oi_1 = create(:fulfilled_order_item, order: order_1, item: item, price: 1, quantity: 25)

      order_2 = create(:order, user: user)
      oi_2 = create(:order_item, order: order_2, item: item, price: 1, quantity: 25)

      order_3 = create(:order, user: user)
      oi_3 = create(:order_item, order: order_3, item: item, price: 1, quantity: 25)
      oi_4 = create(:fulfilled_order_item, order: order_3, item: item, price: 1, quantity: 25)

      visit profile_order_path(order_1)
      expect(page).to have_content("Status: completed")
      expect(page).to_not have_button('Cancel Order')

      within "#oitem-#{oi_1.id}" do
        expect(page).to have_content("Fulfilled: Yes")
      end

      visit(item_path(item))
      expect(page).to have_content("In stock: 100")


      visit profile_order_path(order_2)
      within "#oitem-#{oi_2.id}" do
        expect(page).to have_content("Fulfilled: No")
      end
      expect(page).to have_content("Status: pending")
      expect(page).to have_button('Cancel Order')
      click_button('Cancel Order')

      expect(current_path).to eq(profile_order_path(order_2))
      expect(page).to have_content("Status: cancelled")

      visit(item_path(item))
      expect(page).to have_content("In stock: 125")


      visit profile_order_path(order_3)
      within "#oitem-#{oi_3.id}" do
        expect(page).to have_content("Fulfilled: No")
      end
      within "#oitem-#{oi_4.id}" do
        expect(page).to have_content("Fulfilled: Yes")
      end
      expect(page).to have_content("Status: pending")
      expect(page).to have_button('Cancel Order')
      click_button('Cancel Order')

      expect(current_path).to eq(profile_order_path(order_3))
      expect(page).to have_content("Status: cancelled")
      within "#oitem-#{oi_3.id}" do
        expect(page).to have_content("Fulfilled: No")
      end
      within "#oitem-#{oi_4.id}" do
        expect(page).to have_content("Fulfilled: No")
      end

      visit(item_path(item))
      expect(page).to have_content("In stock: 175")
    end
  end

  context 'as an admin' do
  end
end