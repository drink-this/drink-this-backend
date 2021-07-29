FactoryBot.define do
  factory :cocktail do
    name { Faker::Beer.name }
    thumbnail { Faker::Internet.url }
  end
end
