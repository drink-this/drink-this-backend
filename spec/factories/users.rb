FactoryBot.define do
  factory :user do
    uid { Faker::Number.uid(digits: 21) }
    name { Faker::GreekPhilosophers.name }
    email { Faker::Internet.email }
  end
end
