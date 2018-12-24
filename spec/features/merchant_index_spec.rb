require 'rails_helper'

RSpec.describe 'Merchant Index Page' do
  before(:each) do
    @merchant = create(:merchant)
    @inactive_merchant = create(:inactive_merchant)
  end
  context 'as a non-admin user' do
    it 'should show all active merchants' do
      visit merchants_path

      within "#merchant-#{@merchant.id}" do
        expect(page).to have_content("#{@merchant.name}, #{@merchant.city} #{@merchant.state}")
        expect(page).to have_content(@merchant.created_at)
      end
      expect(page).to_not have_content(@inactive_merchant.name)
    end
  end
  context 'as an admin user' do
    before(:each) do
      admin = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    it 'should show all merchants with enable/disable buttons' do
      visit merchants_path

      within "#merchant-#{@merchant.id}" do
        expect(page).to have_link(@merchant.name)
        expect(page).to have_content("#{@merchant.name}, #{@merchant.city} #{@merchant.state}")
        expect(page).to have_content(@merchant.created_at)
        expect(page).to have_button('Disable')
      end
      within "#merchant-#{@inactive_merchant.id}" do
        expect(page).to have_link(@inactive_merchant.name)
        expect(page).to have_content("#{@inactive_merchant.name}, #{@inactive_merchant.city} #{@inactive_merchant.state}")
        expect(page).to have_content(@inactive_merchant.created_at)
        expect(page).to have_button('Enable')
      end
    end
    it 'should show an admin user a merchant dashboard' do
      visit merchants_path

      within "#merchant-#{@merchant.id}" do
        click_link(@merchant.name)
      end

      expect(current_path).to eq(admin_merchant_path(@merchant))
      expect(page).to have_content("Merchant Dashboard for #{@merchant.name}")
    end
  end
end