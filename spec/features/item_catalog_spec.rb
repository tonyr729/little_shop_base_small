require 'rails_helper'

include ActionView::Helpers::NumberHelper


RSpec.describe 'Item Catalog page' do
  describe 'as any user' do
    it 'should show basic information about each item' do
      items = create_list(:item, 10)
      inactive_item_1 = create(:inactive_item)

      visit items_path

      items.each do |item|
        within "#item-#{item.id}" do
          expect(page).to have_content(item.name)
          expect(page.find("#item-#{item.id}-image")['src']).to have_content(item.image)
          expect(page).to have_content("Sold by: #{item.user.name}")
          expect(page).to have_content("Price: #{number_to_currency(item.price)}")
          expect(page).to have_content("In stock: #{item.inventory}")
        end
      end

      expect(page).to_not have_css("#item-#{inactive_item_1.id}")
      expect(page).to_not have_content(inactive_item_1.name)
      expect(page).to_not have_content("Sold by: #{inactive_item_1.user.name}")
    end
  end
  describe 'as a registered user or visitor' do
  end
end