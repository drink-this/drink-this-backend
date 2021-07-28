FactoryBot.define do
  factory :rating do
    user { nil }
    cocktail { nil }
    stars { 1 }
  end
end
