require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET #new' do
    let(:call_action) { get :new }
    it_behaves_like 'an action requiring no logged in user'
    it 'renders login user page' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'username and password matching' do
      before(:each) do
        user_credentials = { user: { username: user[:username], password: 'password' } }
        post :create, params: user_credentials
      end
      it 'displays success message' do
        expect(flash[:success]).to eq('You have been logged in')
      end
      it 'redirects to user account page' do
        expect(response).to redirect_to(user_url(User.find_by(username: user[:username])))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:call_action) { delete :destroy }
    it_behaves_like 'an action requiring logged in user'
    before(:each) do
      login(user)
      delete :destroy
    end
    it 'resets user session token' do
      expect(user.session_token).not_to eq(User.find_by(id: user.id).session_token)
    end
    it 'sets session token to nil' do
      expect(session[:session_token]).to be_nil
    end
    it 'displays succesful logout message' do
      expect(flash[:success]).to eq('You have been logged out')
    end
    it 'redirects to index page' do
      expect(response).to redirect_to(cats_url)
    end
  end
end
