require 'faker'

User.destroy_all
Cat.destroy_all
CatRentalRequest.destroy_all

8.times do
  user = User.create(
    username: Faker::Name.unique.first_name,
    password: 'password',
    email: Faker::Internet.safe_email
  )

  rand(0..5).times do
    Cat.create(
      birth_date: Faker::Date.between(from: 15.years.ago, to: 1.month.ago),
      color: Cat::COLORS.sample,
      name: Faker::Hipster.unique.word.capitalize,
      sex: %w[M F].sample,
      description: Faker::Hipster.sentence,
      user_id: user.id
    )
  end
end

users = User.all
cats = Cat.all

users.each do |user|
  rand(0..4).times do
    others_cats = cats.reject { |cat| cat.user_id == user.id }
    cat = others_cats.sample
    start_date = Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)
    CatRentalRequest.create(
      cat_id: cat.id,
      user_id: user.id,
      start_date: start_date,
      end_date: Faker::Date.between(from: start_date, to: 13.months.from_now)
    )
  end

end
