FactoryBot.define do
  factory :rating do
    user
    cocktail
    stars { rand(1..5) }
  end
end
