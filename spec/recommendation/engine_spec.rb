require 'rails_helper'
require 'pycall'

RSpec.describe 'Testing' do
  describe 'recommendation model' do
    before :all do
      User.destroy_all
      Cocktail.destroy_all
    end

    it 'can provide a recommendation given other user data' do
      cocktail_1 = create(:cocktail, name: 'margarita')
      cocktail_2 = create(:cocktail, name: 'old fashion')
      cocktail_3 = create(:cocktail, name: 'whisky sour')
      cocktail_4 = create(:cocktail, name: 'godfather')
      cocktail_5 = create(:cocktail, name: 'long island')

      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_4 = create(:user)

      create(:rating, user: user_1, cocktail: cocktail_1, stars: 1)
      create(:rating, user: user_1, cocktail: cocktail_2, stars: 1)
      create(:rating, user: user_1, cocktail: cocktail_3, stars: 5)

      create(:rating, user: user_2, cocktail: cocktail_1, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_2, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_3, stars: 1)
      create(:rating, user: user_2, cocktail: cocktail_4, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_5, stars: 1)

      create(:rating, user: user_3, cocktail: cocktail_1, stars: 5)
      create(:rating, user: user_3, cocktail: cocktail_2, stars: 5)

      create(:rating, user: user_4, cocktail: cocktail_1, stars: 1)
      create(:rating, user: user_4, cocktail: cocktail_3, stars: 5)
      create(:rating, user: user_4, cocktail: cocktail_4, stars: 1)

      expect(RecommendationService.recommendation(user_3.id)).to eq cocktail_4.id
    end

    it 'returns nil if user has rated all the cocktails their similar users have rated' do
      cocktail_1 = create(:cocktail, name: 'margarita')
      cocktail_2 = create(:cocktail, name: 'old fashion')
      cocktail_3 = create(:cocktail, name: 'whisky sour')
      cocktail_4 = create(:cocktail, name: 'godfather')
      cocktail_5 = create(:cocktail, name: 'long island')

      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_4 = create(:user)

      create(:rating, user: user_1, cocktail: cocktail_1, stars: 1)
      create(:rating, user: user_1, cocktail: cocktail_2, stars: 1)
      create(:rating, user: user_1, cocktail: cocktail_3, stars: 5)

      create(:rating, user: user_2, cocktail: cocktail_1, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_2, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_3, stars: 1)
      create(:rating, user: user_2, cocktail: cocktail_4, stars: 5)
      create(:rating, user: user_2, cocktail: cocktail_5, stars: 1)

      create(:rating, user: user_3, cocktail: cocktail_1, stars: 5)
      create(:rating, user: user_3, cocktail: cocktail_2, stars: 5)
      create(:rating, user: user_3, cocktail: cocktail_3, stars: 5)
      create(:rating, user: user_3, cocktail: cocktail_4, stars: 5)
      create(:rating, user: user_3, cocktail: cocktail_5, stars: 5)

      create(:rating, user: user_4, cocktail: cocktail_1, stars: 1)
      create(:rating, user: user_4, cocktail: cocktail_3, stars: 5)
      create(:rating, user: user_4, cocktail: cocktail_4, stars: 1)

      expect(RecommendationService.recommendation(user_3.id)).to eq nil
    end
  end
end
