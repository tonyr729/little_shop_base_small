require 'rails_helper'

RSpec.describe 'Item slugs', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @admin = create(:admin)


    @placeholder_image = 'https://picsum.photos/200/300/?image=524'
    @image = 'https://picsum.photos/200/300/?image=5'

    @name = 'Totally awesome item!'
    @description = 'Item Description 1'
    @price = 9999.99
    @inventory = 10000
  end
  describe 'should create a unique slug apon item creation' do
    scenario 'when logged in as merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      @am_admin = false
      visit new_dashboard_item_path
    end
    scenario 'when logged in as admin' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      @am_admin = true
      visit new_admin_merchant_item_path(@merchant)
    end
    after :each do
      fill_in :item_name, with: @name
      fill_in :item_description, with: @description
      fill_in :item_image, with: @image
      fill_in :item_price, with: @price
      fill_in :item_inventory, with: @inventory
      click_button 'Create Item'
      
      item_1 = Item.last
      
      expect(item_1.name).to eq(@name)
      expect(item_1.slug).to eq('totally-awesome-item')

      if @am_admin
        visit new_admin_merchant_item_path(@merchant)
      else
        visit new_dashboard_item_path
      end
      
      fill_in :item_name, with: @name
      fill_in :item_description, with: @description
      fill_in :item_image, with: @image
      fill_in :item_price, with: @price
      fill_in :item_inventory, with: @inventory
      click_button 'Create Item'

      item_2 = Item.last

      expect(item_2.name).to eq(@name)
      expect(item_2.slug).to eq('totally-awesome-item-2')
      
      if @am_admin
        visit new_admin_merchant_item_path(@merchant)
      else
        visit new_dashboard_item_path
      end

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
  describe 'should only create a new slug if name is updated' do
    before :each do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit new_dashboard_item_path

      fill_in :item_name, with: @name
      fill_in :item_description, with: @description
      fill_in :item_image, with: @image
      fill_in :item_price, with: @price
      fill_in :item_inventory, with: @inventory
      click_button 'Create Item'
      
      @item = Item.last
    end
    scenario 'when logged in as merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      @am_admin = false
      visit edit_dashboard_item_path(@item)
    end
    scenario 'when logged in as admin' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      @am_admin = true
      visit edit_admin_merchant_item_path(@merchant, @item)
    end
    after :each do
      item_slug = @item.slug.dup

      fill_in :item_image, with: ""
      click_button 'Update Item'

      updated_item = Item.find(@item.id)

      expect(updated_item.slug).to eq(item_slug)

      if @am_admin
        visit edit_admin_merchant_item_path(@merchant, @item)
      else
        visit edit_dashboard_item_path(@item)
      end

      fill_in :item_name, with: "Updated Name"
      click_button 'Update Item'
      updated_item = Item.find(@item.id)
      expect(updated_item.slug).to eq('updated-name')
    end
  end
end
