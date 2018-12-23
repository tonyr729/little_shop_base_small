require 'rails_helper'

RSpec.describe 'Visitor Nav', type: :feature do
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
end