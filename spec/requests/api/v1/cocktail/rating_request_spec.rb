require 'rails_helper'

RSpec.describe 'Rating API' do
  describe 'show response endpoint' do
    before :all do
      User.destroy_all
      Cocktail.destroy_all
      @cocktail_1 = create(:cocktail)
      @user_1 = create(:user)
    end

    it 'can send rating of a specific cocktail' do
      post "/api/v1/cocktails/#{@cocktail_1.id}/rating", params: {
        user_id: @user_1.id,
        cocktail_id: @cocktail_1.id,
        stars: 3
      }

      expect(response.status).to eq(201)

      cocktail_1_rating = JSON.parse(response.body, symbolize_names: true)
      rating = Rating.find(cocktail_1_rating[:data][:id])

      expect(cocktail_1_rating).to have_key(:data)
      expect(cocktail_1_rating[:data]).to be_a Hash

      expect(cocktail_1_rating[:data][:type]).to eq("cocktail_rating")
      expect(cocktail_1_rating[:data][:attributes][:user_id]).to eq(rating.user_id)
      expect(cocktail_1_rating[:data][:attributes][:cocktail_id]).to eq(rating.cocktail_id)
      expect(cocktail_1_rating[:data][:attributes][:stars]).to eq(rating.stars)
    end
  end
end
