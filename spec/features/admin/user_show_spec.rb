require 'rails_helper'

RSpec.describe 'Admin User Show workflow', type: :feature do
  describe 'user show page' do
    before(:each) do
      admin = create(:admin)
      @user_1 = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    it 'displays a list of all regular users' do
      visit admin_users_path

      within "#user-#{@user_1.id}" do
        click_link(@user_1.name)
      end

      expect(current_path).to eq(admin_user_path(@user_1))

      expect(page).to have_content("Profile Page for #{@user_1.name}")
      expect(page).to have_content(@user_1.email)
      within '#address' do
        expect(page).to have_content(@user_1.address)
        expect(page).to have_content("#{@user_1.city}, #{@user_1.state} #{@user_1.zip}")
      end
      expect(page).to have_link('Edit Profile')
    end
  end
end