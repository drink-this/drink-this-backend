FactoryBot.define do
  factory :user do
    uid { Faker::Number.uid(digits: 21) }
    name { Faker::GreekPhilosophers.name }
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password(min_length: 8) }
  end
end
