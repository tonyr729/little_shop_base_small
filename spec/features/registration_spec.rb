require 'rails_helper'

RSpec.describe 'Registration Workflow', type: :feature do
  it 'allows a visitor to register successfully when all data is entered properly' do
    visit registration_path
    email = "email@gmail.com"
    name = "Ian Douglas"
    address = "123 Main St"
    city = "Denver"
    state = "CO" 
    zip = "80000" 

    fill_in :user_email,	with: email
    fill_in :user_password,	with: "password" 
    fill_in :user_password_confirmation,	with: "password" 
    fill_in :user_name,	with: name
    fill_in :user_address,	with: address 
    fill_in :user_city,	with: city
    fill_in :user_state,	with: state
    fill_in :user_zip,	with: zip
    click_button 'Create User'

    expect(current_path).to eq(profile_path)
    expect(page).to have_content('You are registered and logged in')
    # expect(page).to have_content("Email: #{email}")
    # within '#address' do
    #   expect(page).to have_content(address)
    #   expect(page).to have_content(city)
    #   expect(page).to have_content(state)
    #   expect(page).to have_content(zip)
    # end
  end
  describe 'blocks a visitor from registering' do
    scenario 'when details are missing' do
      visit registration_path

      click_button 'Create User'

      expect(current_path).to eq(users_path)
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip can't be blank")
    end
    scenario 'when email is not unique' do
      email = "email@gmail.com"
      user = create(:user, email: email)

      visit registration_path

      fill_in :user_email,	with: email
      click_button 'Create User'

      expect(current_path).to eq(users_path)
      expect(page).to have_content('Email has already been taken')
    end
  end
end