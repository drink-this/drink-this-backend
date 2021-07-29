FactoryBot.define do
  factory :user do
    name { Faker::GreekPhilosophers.name }
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password(min_length: 8) }
  end
end
