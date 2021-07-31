require 'rails_helper'
require 'pycall'

RSpec.describe 'Testing' do
  describe 'create_df' do
    it 'can convert ruby data into dataframe' do
      cocktail_1 = create(:cocktail, name: 'margarita')
      cocktail_2 = create(:cocktail, name: 'old fashion')
      cocktail_3 = create(:cocktail, name: 'whisky sour')
      cocktail_4 = create(:cocktail, name: 'godfather')
      cocktail_5 = create(:cocktail, name: 'long island')

      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_4 = create(:user)

      create(:rating, user: user_1, cocktail: cocktail_1, stars: 2)
      create(:rating, user: user_1, cocktail: cocktail_2, stars: 2)
      create(:rating, user: user_1, cocktail: cocktail_3, stars: 2)

      create(:rating, user: user_2, cocktail: cocktail_1, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_2, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_3, stars: 2)
      create(:rating, user: user_2, cocktail: cocktail_4, stars: 1)
      create(:rating, user: user_2, cocktail: cocktail_5, stars: 1)

      create(:rating, user: user_3, cocktail: cocktail_1, stars: 2)

      create(:rating, user: user_4, cocktail: cocktail_1, stars: 5)
      create(:rating, user: user_4, cocktail: cocktail_3, stars: 2)
      create(:rating, user: user_4, cocktail: cocktail_4, stars: 1)
      # create(:rating, user: user_4, cocktail: cocktail_5, stars: 1)

      expect(RecommendationService.recommendation(User.last.id)).to be_a? DataFrame
    end
  end

  describe 'testing euclidean distance' do
    xit 'can run python' do
      expect(RecommendationService.recommendation).to eq("Screw Driver") # Should take a user_id or user as a parameter (who's making the request)
    end
  end
end
