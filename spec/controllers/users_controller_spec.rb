require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe 'GET #new' do
    let(:call_action) { get :new }
    it_behaves_like 'an action requiring no logged in user'
    it 'renders new user form page' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before(:each) do
        new_user_params = { username: 'Valid_user', email: 'valid_email@example.com',
                            password: 'password' }
        post :create, params: { user: new_user_params }
      end
      it 'displays success message' do
        expect(flash[:success]).to eq('Your account has been created')
      end
      it 'redirects to new user account page' do
        expect(response).to redirect_to(user_url(User.find_by(username: 'Valid_user').id))
      end
    end
    context 'with invalid params' do
      before(:each) do
        new_user_params = { username: '', email: 'valid_email@example.com',
                            password: 'password' }
        post :create, params: { user: new_user_params }
      end
      it 'displays errors message' do
        expect(flash[:danger]).to_not be_nil
      end
      it 'renders new user form page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    let(:call_action) { get :show, params: { id: user.id } }
    it_behaves_like 'an action requiring logged in user'
    context 'user to show is the current user' do
      it 'renders user show page' do
        login(user)
        get :show, params: { id: user.id }
        expect(response).to render_template(:show)
      end
    end
    context 'user to show is not the current user' do
      it 'redirects to index page' do
        login(another_user)
        get :show, params: { id: user.id }
        expect(response).to redirect_to(cats_url)
      end
    end
  end

  describe 'GET #edit' do
    let(:call_action) { get :edit, params: { id: user.id } }
    it_behaves_like 'an action requiring logged in user'
    context 'user to edit is the current user' do
      it 'renders user edit form page' do
        login(user)
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end
    end
    context 'user to edit is not the current user' do
      it 'redirects to index page' do
        login(another_user)
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(cats_url)
      end
    end
  end

  describe 'POST #update' do
    context 'with valid params' do
      before(:each) do
        login(user)
        user.username = 'Valid_user'
        user_params = user.attributes
        post :update, params: { id: user.id, user: user_params }
      end
      it 'displays success message' do
        expect(flash[:success]).to eq('Your account has been succesfully updated')
      end
      it 'redirects to user account page' do
        expect(response).to redirect_to(user_url(User.find_by(username: 'Valid_user').id))
      end
    end
    context 'with invalid params' do
      before(:each) do
        login(user)
        user.username = ''
        user_params = user.attributes
        post :update, params: { id: user.id, user: user_params }
      end
      it 'displays errors message' do
        expect(flash[:danger]).to_not be_nil
      end
      it 'renders edit user form page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:call_action) { delete :destroy, params: { id: user.id } }
    it_behaves_like 'an action requiring logged in user'
    it 'deletes user account' do
      user.update(username: 'Deleted_user')
      login(user)
      delete :destroy, params: { id: user.id }
      expect(User.find_by(username: 'Deleted_user')).to be_nil
    end
    it 'redirects to index page' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(cats_url)
    end
  end
end
