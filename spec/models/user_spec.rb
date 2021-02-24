require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user) { FactoryBot.build(:user) }

  describe 'before validation' do
    it 'sets the session token before validation' do
      user.session_token = nil
      user.valid?
      expect(user.session_token).not_to be_nil
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_presence_of(:password_digest) }
    it { is_expected.to validate_uniqueness_of(:session_token) }
    it { is_expected.to validate_length_of(:password).is_at_least(6).allow_nil }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:cats) } 
    it { is_expected.to have_many(:requests) } 
  end

  describe 'class methods' do
    
    describe '::confirm_credentials' do
      
      before(:each) do
        user.save
      end

      context 'username and password match' do
        it 'returns user' do

          confirmed = User.confirm_credentials(user.username, user.password)
          expect(confirmed).to eq(user)
        end
      end

      context "username and password do not match" do
        it 'returns nil' do
          unconfirmed = User.confirm_credentials(user.username, 'unmatched')
          expect(unconfirmed).to be_nil
        end
      end
      
    end

    describe '#reset_session_token' do
      it 'resets session token' do
        user.valid?
        token_before_reset = user.session_token
        user.reset_session_token
        token_after_reset = user.session_token
        expect(token_before_reset).not_to eq(token_after_reset)
      end
      
    end
    
    
  end
  
end