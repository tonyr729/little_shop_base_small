require 'rails_helper'

RSpec.describe 'Cart workflow', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, user: @merchant)
  end

  context 'as a visitor' do
    it 'shows an empty cart when no items are added' do
      visit cart_path

      expect(page).to have_content('Your cart is empty')
      expect(page).to_not have_button('Emtpy cart')
    end

    it 'allows visitors to add items to cart' do
      visit item_path(@item)
      click_button "Add to Cart"

      expect(page).to have_content("You have 1 package of #{@item.name} in your cart")
      expect(page).to have_link("Cart: 1")
      expect(current_path).to eq(items_path)

      visit item_path(@item)
      click_button "Add to Cart"

      expect(page).to have_content("You have 2 packages of #{@item.name} in your cart")
      expect(page).to have_link("Cart: 2")
    end
  end

  context 'as a registered user' do
    before :each do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end
    it 'shows an empty cart when no items are added' do
      visit cart_path

      expect(page).to have_content('Your cart is empty')
      expect(page).to_not have_button('Emtpy cart')
    end
    it 'allows visitors to add items to cart' do
      visit item_path(@item)
      click_button "Add to Cart"

      expect(page).to have_content("You have 1 package of #{@item.name} in your cart")
      expect(page).to have_link("Cart: 1")
      expect(current_path).to eq(items_path)

      visit item_path(@item)
      click_button "Add to Cart"

      expect(page).to have_content("You have 2 packages of #{@item.name} in your cart")
      expect(page).to have_link("Cart: 2")
    end
  end

  context 'as a merchant' do
    it 'does not allow merchants to add items to a cart' do
      merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit item_path(@item)

      expect(page).to_not have_button("Add to cart")
    end
  end

  context 'as an admin' do
    it 'does not allow admins to add items to a cart' do
      merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit item_path(@item)

      expect(page).to_not have_button("Add to cart")
    end
  end
end