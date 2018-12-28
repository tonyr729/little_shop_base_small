require 'rails_helper'

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
  end

  context 'as an admin' do
  end
end