FactoryBot.define do
  factory :user do
    name { Faker::GreekPhilosophers.name }
    email { Faker::Internet.email }
    google_token { Faker::Blockchain::Ethereum.address }
    google_refresh_token { Faker::Blockchain::Ethereum.address }
  end
end
