require 'rails_helper'

RSpec.describe 'Rating API' do
  describe 'show response endpoint' do
    it 'can send rating of a specific cocktail' do
      cocktail_1 = create(:cocktail, name: 'margarita')
      user_1 = create(:user)
      cocktail_1_rating = ({
        user: user_1,
        cocktail: cocktail_1,
        stars: 3
        })

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/v1/cocktails/#{cocktail_1.id}/rating", headers: headers, params: JSON.generate(rating: cocktail_1_rating)

      expect(response).to be_successful
      expect(response.status).to eq(201)

    end
  end
end
