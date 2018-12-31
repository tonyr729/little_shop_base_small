require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Item show page', type: :feature do
  describe 'as a visitor or registered user' do
    it 'should show details about a single item' do
      merchant = create(:merchant)
      item = create(:item, user: merchant)
      user = create(:user)
      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item, created_at: 4.days.ago, updated_at: 3.days.ago)
      create(:fulfilled_order_item, order: order, item: item, created_at: 1.hour.ago, updated_at: 30.minutes.ago)

      visit item_path(item)

      within "#item-#{item.id}" do
        expect(page).to have_content(item.name)
        expect(page.find("#item-#{item.id}-image")['src']).to have_content(item.image)
        expect(page).to have_content("Sold by: #{item.user.name}")
        expect(page).to have_content("Price: #{number_to_currency(item.price)}")
        expect(page).to have_content("In stock: #{item.inventory}")
        expect(page).to have_content("Average time to fulfill: 12 hours, 15 minutes")
      end

    end
  end
end