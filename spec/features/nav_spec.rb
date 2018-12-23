require 'rails_helper'

RSpec.describe 'Site Nav', type: :feature do
  it 'should show proper links for all visitors' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)

    visit root_path

    click_link 'Items'
    expect(current_path).to eq(items_path)

    click_link 'Merchants'
    expect(current_path).to eq(merchants_path)

    click_link 'Cart'
    expect(current_path).to eq(cart_path)

    click_link 'Log in'
    expect(current_path).to eq(login_path)

    click_link 'Register'
    expect(current_path).to eq(registration_path)

    click_link 'Home'
    expect(current_path).to eq(root_path)
  end
  it 'should show proper links for all users logged in' do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit root_path

    click_link 'Profile'
    expect(current_path).to eq(profile_path)

    click_link 'Orders'
    expect(current_path).to eq(profile_orders_path)

    click_link 'Log out'
    expect(current_path).to eq(root_path)

    expect(page).to_not have_link('Log In')
    expect(page).to_not have_link('Register')
  end
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
  it 'should show proper links for all admins logged in' do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit root_path

    click_link 'Users'
    expect(current_path).to eq(admin_users_path)

    click_link 'Dashboard'
    expect(current_path).to eq(admin_dashboard_index_path)

    expect(page).to_not have_link('Profile')
    expect(page).to_not have_link('Log In')
    expect(page).to_not have_link('Register')
  end
end