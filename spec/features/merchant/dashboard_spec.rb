require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Dashboard page' do
  context 'as a merchant' do
    it 'should show my dashboard information' do
      merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit dashboard_path

      expect(page).to have_content("Merchant Dashboard for #{merchant.name}")
      expect(page).to have_content(merchant.email)
      within '#address' do
        expect(page).to have_content(merchant.address)
        expect(page).to have_content("#{merchant.city}, #{merchant.state} #{merchant.zip}")
      end
      expect(page).to_not have_link('Edit Profile')
    end
    describe 'should show pending orders containing items I sell' do
      scenario "unless I don't have any..." do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
        visit dashboard_path

        within '#orders' do
          expect(page).to have_content("You don't have any pending orders to fulfill")
        end
      end
      scenario 'when I have orders pending' do
        merchant = create(:merchant)
        item = create(:item, user: merchant)
        orders = create_list(:order, 2)
        create(:order_item, order: orders[0], item: item, price: 1, quantity: 1)
        create(:order_item, order: orders[1], item: item, price: 1, quantity: 1)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        visit dashboard_path
        within '#orders' do
          expect(page).to_not have_content("You don't have any pending orders to fulfill")
          orders.each do |order|
            within "#order-#{order.id}" do
              expect(page).to have_link("Order ID #{order.id}")
              expect(page).to have_content("Created: #{order.created_at}")
              expect(page).to have_content("Items in Order: #{order.my_item_count(merchant.id)}")
              expect(page).to have_content("Value of Order: #{number_to_currency(order.my_revenue_value(merchant.id))}")
            end
          end
        end
      end
    end
  end

  context 'as an admin' do
  end
end