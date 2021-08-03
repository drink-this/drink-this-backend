FactoryBot.define do
  factory :user do
    uid { Faker::Number.number(digits: 21) }
    name { Faker::GreekPhilosophers.name }
    email { Faker::Internet.email }
    google_token { Faker::Blockchain::Ethereum.address }
    google_refresh_token { Faker::Blockchain::Ethereum.address }
  end
end
