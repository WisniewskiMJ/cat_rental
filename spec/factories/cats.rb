FactoryBot.define do
  factory :cat do
    birth_date { Faker::Date.between(from: 15.years.ago, to: 1.month.ago) }
    color { Cat::COLORS.sample }
    name { Faker::Hipster.unique.word.capitalize }
    sex { %w[M F].sample }
    description { Faker::Hipster.sentence }
    user_id { FactoryBot.build(:user).id }
  end
end
