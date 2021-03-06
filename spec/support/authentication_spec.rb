shared_examples_for 'an action requiring logged in user' do
  let(:user) { FactoryBot.create(:user) }

  context 'user logged in' do
    before do
      login(user)
      call_action
    end

    it 'does not display not logged in warning message' do
      expect(flash[:danger]).not_to eq('You have to be logged in to access that section')
    end
  end

  context 'no user is logged in' do
    before do
      user.reset_session_token
      call_action
    end

    it 'displays not logged in warning message' do
      expect(flash[:danger]).to eq('You have to be logged in to access that section')
    end
  end
end

shared_examples_for 'an action requiring no logged in user' do
  let(:user) { FactoryBot.create(:user) }

  context 'no user is logged in' do
    before do
      user.reset_session_token
      call_action
    end
    it 'does not display logged in warning message' do
      expect(flash[:danger]).not_to eq('You can not perform that action while logged in')
    end
  end

  context 'user logged in' do
    before do
      login(user)
      call_action
    end
    it 'displays logged in warning message' do
      expect(flash[:danger]).to eq('You can not perform that action while logged in')
    end
    it 'redirects to index page' do
      expect(response).to redirect_to(cats_url)
    end
  end
end
