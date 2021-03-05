require 'rails_helper'

feature 'cat features', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:cat) { FactoryBot.create(:cat, user_id: user.id) }

  feature 'viewing cat show page' do
    scenario 'views cat show page' do
      visit cat_url(cat.id)
      expect(page).to have_content(cat.name)
    end
  end

  feature 'adding a cat' do
    scenario 'gets new cat form ' do
      login_user(user.username, 'password')
      visit cats_url
      click_on 'Add a cat'
      expect(page).to have_content('Add a new cat')
    end
    scenario 'fills new cat form with valid params' do
      login_user(user.username, 'password')
      create_cat('Valid_cat', '01/01/2020', 'grey', 'F','Description of a cat')
      expect(page).to have_content('You have succesfully added a new cat')
    end
      scenario 'fills new cat form with invalid params' do
      login_user(user.username, 'password')
      create_cat('Invalid_cat', '01/01/2020', 'grey', 'F', '')
      expect(page).to have_content('Add a new cat')
    end
  end 

  feature 'renting a cat' do
    scenario 'gets rental request form from index page' do
      login_user(user.username, 'password')
      visit cats_url
      click_on 'Rent a cat'
      expect(page).to have_content('Make a request')
    end
    scenario 'gets rental request form from cat show page' do
      login_user(user.username, 'password')
      visit cat_url(cat.id)
      click_on 'Rent'
      expect(page).to have_content('Make a request')
    end
    scenario 'fills rent request form with valid params' do
      login_user(user.username, 'password')
      rent_cat(cat.name, Date.tomorrow, Date.today.next_week)
      expect(page).to have_content('Your request has been submitted')
    end
    scenario 'fills rent request form with invalid params' do
      login_user(user.username, 'password')
      rent_cat(cat.name, Date.tomorrow, Date.today.last_week)
      expect(page).to have_content('Make a request')
    end
  end
end