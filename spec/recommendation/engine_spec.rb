require 'rails_helper'
require 'pycall'

RSpec.describe 'Testing' do
  describe 'create_df' do
    it 'can convert ruby data into dataframe' do
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

      expect(RecommendationService.create_df).to be_a? DataFrame
    end
  end

  describe 'testing euclidean distance' do
    it 'can run python' do
      expect(RecommendationService.recommendation).to eq("Screw Driver") # Should take a user_id or user as a parameter (who's making the request)
    end
  end
end
