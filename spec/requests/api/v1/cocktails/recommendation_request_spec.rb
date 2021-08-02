require 'rails_helper'

RSpec.describe '/recommendation', :vcr do
  VCR.use_cassette('cocktail drink', :record => :new_episodes) do
    describe 'GET /recommendation' do
      it 'provides a random cocktail for the first user'

      it 'returns a recommendation based on other user data' do
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

        get "/api/v1/recommendation"

        expect(response.status).to eq(200)

        result = JSON.parse(response.body, symbolize_names: true)

        expect(result[:data]).to be_a Hash
        expect(result[:data][:id]).to eq(@cocktail_1.id.to_s)
        expect(result[:data][:type]).to eq('cocktail')

        attributes = result[:data][:attributes]

        expect(attributes).to be_a Hash
        expect(attributes).to have_key :name
        expect(attributes[:name]).to eq('Vodka Fizz')

        expect(attributes).to have_key :thumbnail
        expect(attributes).to have_key :glass
        expect(attributes).to have_key :recipe
        expect(attributes).to have_key :instructions
        expect(attributes).to have_key :rating
        expect(attributes[:rating]).to eq(4)
      end

      
    end
  end
end
