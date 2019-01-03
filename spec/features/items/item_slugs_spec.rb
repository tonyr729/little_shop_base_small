require 'rails_helper'

RSpec.describe 'Item slugs', type: :feature do
  describe 'slug creation' do
    context 'as a merchant' do
      before :each do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        visit new_dashboard_item_path

        @placeholder_image = 'https://picsum.photos/200/300/?image=524'
        @image = 'https://picsum.photos/200/300/?image=5'

        @name = 'Totally awesome item!'
        @description = 'Item Description 1'
        @price = 9999.99
        @inventory = 10000

        fill_in :item_name, with: @name
        fill_in :item_description, with: @description
        fill_in :item_image, with: @image
        fill_in :item_price, with: @price
        fill_in :item_inventory, with: @inventory
        click_button 'Create Item'
      end
      it 'should create a unique slug apon item creation' do
        item_1 = Item.last
        
        expect(item_1.name).to eq(@name)
        expect(item_1.slug).to eq('totally-awesome-item')

        visit new_dashboard_item_path

        fill_in :item_name, with: @name
        fill_in :item_description, with: @description
        fill_in :item_image, with: @image
        fill_in :item_price, with: @price
        fill_in :item_inventory, with: @inventory
        click_button 'Create Item'

        item_2 = Item.last

        expect(item_2.name).to eq(@name)
        expect(item_2.slug).to eq('totally-awesome-item-2')
        
        visit new_dashboard_item_path

        fill_in :item_name, with: @name
        fill_in :item_description, with: @description
        fill_in :item_image, with: @image
        fill_in :item_price, with: @price
        fill_in :item_inventory, with: @inventory
        click_button 'Create Item'

        item_3 = Item.last

        expect(item_3.name).to eq(@name)
        expect(item_3.slug).to eq('totally-awesome-item-3')
      end
    end
  end
end