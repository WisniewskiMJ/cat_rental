require 'rails_helper'

feature 'user features', type: :feature do

  feature 'visiting main page' do
    scenario 'visits index page' do
      visit cats_url
      expect(page).to have_content('All cats')
    end
  end
  
  feature 'registering new user' do
    scenario 'gets new user form' do
      visit cats_url
      click_on 'Register'
      expect(page).to have_content('Username')
    end
    scenario 'fills new user form with valid params' do
      create_user('Valid_user', 'valid_user@example.com', 'password')
      expect(page).to have_content('Your account has been created')
    end
    scenario 'fills new user form with invalid params' do
      create_user('Valid_user', '', 'password')
      expect(page).to have_content('Username')
    end
  end

  feature 'signing user in' do
      let(:user) { FactoryBot.create(:user) }
    scenario 'gets login form' do
      visit cats_url
      click_on 'Log in'
      expect(page).to have_content('Username')
    end
    scenario 'fills login form with valid params' do
      login_user(user.username, 'password')
      expect(page).to have_content('You have been logged in')
    end
    scenario 'fills login form with invalid params' do
      login_user('Invalid_user', 'password')
      expect(page).to have_content('Username')
    end
  end

  feature 'editing user' do
    let(:user) { FactoryBot.create(:user) }
    scenario 'gets edit user form' do
      login_user(user.username, 'password')
      click_on 'Edit account'
      expect(page).to have_content('Edit account')
    end
    scenario 'fills edit user form with valid params' do
      login_user(user.username, 'password')
      edit_user(user.id, 'Different_name', 'different_email@example.com', 'password')
      expect(page).to have_content('Your account has been succesfully updated')
    end
    scenario 'fills edit user form with invalid params' do
      login_user(user.username, 'password')
      edit_user(user.id, 'Different_name', '', 'password')
      expect(page).to have_content('Edit account')
    end
  end

  feature 'deleting user' do
    let(:user) { FactoryBot.create(:user) }
    scenario 'deletes user' do
      login_user(user.username, 'password')
      click_on 'Delete account'
      expect(User.find_by(username: user.username)).to be_nil
    end
  end
end