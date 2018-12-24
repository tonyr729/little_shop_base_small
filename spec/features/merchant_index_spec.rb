require 'rails_helper'

RSpec.describe 'Merchant Index Page' do
  context 'as a non-admin user' do
    it 'should show all active merchnats' do
      merchant = create(:merchant)
      inactive_merchant = create(:inactive_merchant)

      visit merchants_path

      within "#merchant-#{merchant.id}" do
        expect(page).to have_content("#{merchant.name}, #{merchant.city} #{merchant.state}")
        expect(page).to have_content(merchant.created_at)
      end
      expect(page).to_not have_content(inactive_merchant.name)
    end
  end
  context 'as an admin user' do
  end
end