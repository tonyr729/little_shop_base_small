require 'rails_helper'

RSpec.describe 'Merchant Nav', type: :feature do
  it 'should show proper links for all merchants logged in' do
    merchant = create(:merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    visit root_path

    click_link 'Dashboard'
    expect(current_path).to eq(dashboard_path)

    expect(page).to_not have_link('Profile')
    expect(page).to_not have_link('Cart')
    expect(page).to_not have_link('Log In')
    expect(page).to_not have_link('Register')
  end
end