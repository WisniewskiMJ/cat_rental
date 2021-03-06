FactoryBot.define do
  factory :cat_rental_request do
    cat_id { FactoryBot.build(:cat).id }
    user_id { FactoryBot.build(:user).id }
    start_date { Date.tomorrow }
    end_date { Date.today.next_week }
  end
end
