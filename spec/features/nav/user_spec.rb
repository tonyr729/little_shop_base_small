require 'rails_helper'

RSpec.describe 'User Nav', type: :feature do
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
end