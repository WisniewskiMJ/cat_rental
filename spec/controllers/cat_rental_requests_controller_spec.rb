require 'rails_helper'

RSpec.describe CatRentalRequestsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:cat) { FactoryBot.create(:cat, user_id: user.id, name: 'Valid_cat') }
  let(:cat_request) { FactoryBot.build(:cat_rental_request, cat_id: cat.id, user_id: user.id) }
  let(:overlapping_cat_request) { FactoryBot.build(:cat_rental_request, cat_id: cat.id, user_id: user.id) }
  before(:each) do
    login(user)
  end

  describe 'GET #new' do
    let(:call_action) { get :new }
    it_behaves_like 'an action requiring logged in user'
    it 'renders new request form page' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      before(:each) do
        request_params = cat_request.attributes
        post :create, params: { cat_rental_request: request_params }
      end
      it 'shows success message' do
        expect(flash[:success]).to eq('Your request has been submitted')
      end
      it 'redirects to requested cat show page' do
        expect(response).to redirect_to(cat_url(Cat.find_by(name: 'Valid_cat').id))
      end
    end

    context 'with invalid parameters' do
      before(:each) do
        cat_request.start_date = nil
        request_params = cat_request.attributes
        post :create, params: { cat_rental_request: request_params }
      end
      it 'shows errors message' do
        expect(flash[:danger]).to_not be_nil
      end
      it 'redirects to new request form' do
        expect(response).to redirect_to(new_cat_rental_request_url(cat_id: cat_request[:cat_id]))
      end
    end
  end

  describe 'POST approve' do
    before(:each) do
      cat_request.save
      overlapping_cat_request.save
      post :approve, params: { id: cat_request[:id] }
    end
    it 'sets request status to approved' do
      accepted_request = CatRentalRequest.find_by(id: cat_request[:id])
      expect(accepted_request[:status]).to eq('approved')
    end
    it 'sets overlapping requests statuses to denied' do
      denied_request = CatRentalRequest.find_by(id: overlapping_cat_request[:id])
      expect(denied_request[:status]).to eq('denied')
    end
    it 'redirects to requested cat show page' do
      expect(response).to redirect_to(cat_url(Cat.find_by(name: 'Valid_cat').id))
    end
  end

  describe 'POST deny' do
    before(:each) do
      cat_request.save
      post :deny, params: { id: cat_request[:id] }
    end
    it 'sets request status to denied' do
      denied_request = CatRentalRequest.find_by(id: cat_request[:id])
      expect(denied_request[:status]).to eq('denied')
    end
    it 'redirects to requested cat show page' do
      expect(response).to redirect_to(cat_url(Cat.find_by(name: 'Valid_cat').id))
    end
  end
end
