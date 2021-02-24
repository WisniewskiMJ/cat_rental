FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.first_name }
    password { 'password' }
    email { Faker::Internet.safe_email }
  end
end
