shared_examples_for 'an action requiring logged in user' do
  let(:user) { FactoryBot.create(:user) }
  context 'when user logged in' do
    before do
      login(user)
      call_action
    end

    it 'does not show not logged in message' do
      expect(flash[:danger]).not_to eq('You have to be logged in to access that section')
    end
  end

  context 'when no user is logged in' do
    before do
      user.reset_session_token
      call_action
    end
    it 'redirects to index page' do
      expect(response).to redirect_to(cats_url)
    end
    it 'displays not logged in message' do
      expect(flash[:danger]).to eq('You have to be logged in to access that section')
    end
  end
end