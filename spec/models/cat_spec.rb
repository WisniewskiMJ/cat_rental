require 'rails_helper'

RSpec.describe Cat, type: :model do
  
  describe 'validations' do
    it { should validate_presence_of(:birth_date) }
    it { should validate_presence_of(:color) }
    it { should validate_inclusion_of(:color).
                in_array(%w[black grey white buff brown orange tortoiseshell calico]) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:sex) }
    it { should validate_inclusion_of(:sex).
                in_array(%w[M F]) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).
                is_at_least(3).is_at_most(300) }
    it { should validate_presence_of(:owner) }
  end

  describe 'associations' do
    it { should belong_to(:owner) }
    it { should have_many(:rental_requests).dependent(:destroy) }
  end

end
