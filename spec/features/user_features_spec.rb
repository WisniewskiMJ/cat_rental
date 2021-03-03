require 'rails_helper'

feature 'user features', type: :feature do
  
  feature 'registering new user' do
    scenario 'visits index page' do
      visit cats_url
      expect(page).to have_content('All cats')
    end
    scenario 'gets new user form' do
      visit cats_url
      click_on 'Register'
      expect(page).to have_content('Username')
    end
    scenario 'fills form with valid params' do
      visit new_user_url
      fill_in 'user[username]', with: 'Valid_user'
      fill_in 'user[email]', with: 'valid_user@example.com'
      fill_in 'user[password]', with: 'password'
      within '.box' do
        click_on 'Register'
      end
      expect(page).to have_content('Your account has been created')
    end
    scenario 'fills form with invalid params' do
      visit new_user_url
      fill_in 'user[username]', with: 'Invalid_user'
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: 'password'
      within '.box' do
        click_on 'Register'
      end
      expect(page).to have_content('Username')
    end
  end

end