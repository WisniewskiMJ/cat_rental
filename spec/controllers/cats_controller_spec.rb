require 'rails_helper'

RSpec.describe CatsController, type: :controller do

  let(:user) { FactoryBot.create(:user) }
  let(:cat_saved) { FactoryBot.create(:cat, user_id: user.id) }
  let(:cat_unsaved) { FactoryBot.build(:cat, user_id: user.id) }
  
  before(:each) do
    login(user)
  end
  
  describe 'GET #index' do
    it 'renders the index page' do
      get :index
      expect(response).to render_template(:index)
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    context 'cat exists' do
      it 'renders the show page' do
        get :show, params: {id: cat_saved.id}
        expect(response).to render_template(:show)
        expect(response).to be_successful
      end
    end    
    context 'cat does not exist' do
      it 'redirects to index page' do
        get :show, params: {id: -1}
        expect(response).to redirect_to(cats_url)
      end
    end
  end

  describe 'GET #new' do
    context 'user is logged in' do
      it 'renders new cat form page' do
        get :new
        expect(response).to render_template(:new)
        expect(response).to be_successful
      end
    end
    context 'no user is logged in' do
      it 'redirects to index page' do
        user.reset_session_token
        get :new
        expect(response).to redirect_to(cats_url)
      end
      it 'displays not logged in message' do
        user.reset_session_token
        get :new
        expect(flash[:danger]).to eq('You have to be logged in to access that section')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before(:each) do
        cat_unsaved[:name] = 'Valid_cat'
        cat_params = cat_unsaved.attributes
        post :create, params: { cat: cat_params }
      end
      it 'shows success message' do
        expect(flash[:success]).to eq('You have succesfully added a new cat')
      end
      it 'renders the show page of new cat'do
        expect(response).to redirect_to(cat_url(Cat.find_by(name: 'Valid_cat')))
      end
    end
    context 'with invalid params' do
      before(:each) do
        cat_unsaved[:name] = ''
        cat_params = cat_unsaved.attributes
        post :create, params: { cat: cat_params }
      end
      it 'shows errors message' do
        expect(flash[:danger]).to_not be_nil
      end
      it 'renders new cat form' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'user is owner of a cat' do
      it 'renders edit cat page' do
        get :edit, params: { id: cat_saved.id }
        expect(response).to render_template(:edit)
      end
    end
    context 'user is not owner of a cat' do
      it 'redirects to index page' do
        other_user = FactoryBot.create(:user)
        cat_unsaved.user_id = other_user.id
        cat_unsaved.name = 'Others_cat'
        cat_unsaved.save
        get :edit, params: { id: Cat.find_by(name: 'Others_cat').id }
        expect(response).to redirect_to(cats_url)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      before(:each) do
        cat_saved[:name] = 'Valid_cat'
        cat_params = cat_saved.attributes
        patch :update, params: { id: cat_saved.id, cat: cat_params }
      end
      it 'shows success message' do
        expect(flash[:success]).to eq('Your cat has been succesfully updated')
      end
      it 'renders the show page of new cat' do
        expect(response).to redirect_to(cat_url(Cat.find_by(name: 'Valid_cat')))
      end
    end
    context 'with invalid params' do
      before(:each) do
        cat_saved[:name] = ''
        cat_params = cat_saved.attributes
        patch :update, params: { id: cat_saved.id, cat: cat_params }
      end
      it 'shows errors message' do
        expect(flash[:danger]).to_not be_nil
      end
      it 'renders new cat form' do
        expect(response).to render_template(:edit)
      end
    end
  end

end

