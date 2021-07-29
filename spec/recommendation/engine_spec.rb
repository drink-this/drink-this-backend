require 'rails_helper'

RSpec.describe 'Testing' do
  describe 'say_hello' do
    xit 'can run python' do
      cocktail_1 = create(:cocktail, name: 'margarita')
      cocktail_2 = create(:cocktail, name: 'old fashion')
      cocktail_3 = create(:cocktail, name: 'whisky sour')

      create(:user) do
        create(:rating, cocktail: cocktail_1, stars: 2)
        create(:rating, cocktail: cocktail_2, stars: 2)
        create(:rating, cocktail: cocktail_3, stars: 2)
      end

      create(:user) do
        create(:rating, cocktail: cocktail_1, stars: 5)
        create(:rating, cocktail: cocktail_2, stars: 5)
        create(:rating, cocktail: cocktail_3, stars: 2)
      end

      create(:user) do
        create(:rating, cocktail: cocktail_1, stars: 5)
      end

      expect(RecommendationService.say_hello).to eq("hello world")
    end
  end

  describe 'testing euclidean distance' do
    it 'can run python' do
      expect(RecommendationService.recommendation).to eq("") # Should take a user_id or user as a parameter (who's making the request)
    end
  end
end
