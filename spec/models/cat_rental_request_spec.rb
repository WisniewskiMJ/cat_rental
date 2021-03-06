require 'rails_helper'
require 'date'

RSpec.describe CatRentalRequest, type: :model do
  user = FactoryBot.create(:user)
  cat = FactoryBot.create(:cat, user_id: user.id)
  subject(:request) { FactoryBot.build(:cat_rental_request, cat_id: cat.id, user_id: user.id) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:cat_id) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:status) }

    it 'validates end_date not earlier than start_date' do
      request.start_date = Date.tomorrow.next_week
      request.end_date = Date.tomorrow
      puts request.attributes
      request.valid?
      expect(request.errors[:end_date]).to eq(['can not be earlier than start'])
    end

    it 'validates start_date not in the past' do
      request.start_date = Time.zone.today.last_week
      request.valid?
      expect(request.errors[:start_date]).to eq(['can not be in the past'])
    end

    it 'validates request does not overlap with approved request' do
      request.assign_attributes(status: :approved)
      request.save
      new_request = FactoryBot.build(:cat_rental_request, cat_id: cat.id)
      new_request.valid?
      expect(new_request.errors[:overlaps]).to eq(['with approved request'])
    end
  end

  describe 'associations' do
    it { should belong_to(:requester) }
    it { should belong_to(:cat) }
  end

  describe 'class methods' do
    describe '#approve!' do
      context 'status is not pending' do
        it 'raises error if status is not pending' do
          request.status = :approved
          expect { request.approve! }.to raise_error(RuntimeError, 'status is not pending')
        end
      end

      context 'status is pending' do
        it 'denies other overlapping requests' do
          request.save
          other_request = FactoryBot.create(:cat_rental_request,
                                            cat_id: request.cat_id, user_id: user.id)
          request.approve!
          expect(CatRentalRequest.find(other_request.id).status).to eq('denied')
        end

        it 'changes request status to approved' do
          request.approve!
          expect(request.status).to eq('approved')
        end
      end
    end

    describe '#deny!' do
      it 'changes request status to denied' do
        request.deny!
        expect(request.status).to eq('denied')
      end
    end
  end
end
