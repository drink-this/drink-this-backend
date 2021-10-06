require 'rails_helper'

RSpec.describe '/recommendation', :vcr do
  VCR.use_cassette('cocktail drink', :record => :new_episodes) do
    describe 'GET /recommendation' do
      before :all do
        User.destroy_all
        Cocktail.destroy_all
        Rating.destroy_all
      end
      
      context 'user is not logged in' do
        it 'returns an error message and 404 status code' do
          get "/api/v1/recommendation"

          expect(response).to have_http_status 404
          expect(response.body).to match(/Couldn't find User/)
        end
      end
      
      context 'user is logged in and other users are present' do
        it 'returns a recommendation based on other user data' do
          cocktail_1 = create(:cocktail, name: 'margarita')
          cocktail_2 = create(:cocktail, name: 'old fashioned', id: 11001)
          cocktail_3 = create(:cocktail, name: 'whisky sour')
          cocktail_4 = create(:cocktail, name: 'godfather', id: 11423)
          cocktail_5 = create(:cocktail, name: 'long island')

          user_1 = create(:user)
          user_2 = create(:user)
          user_3 = create(:user, google_token: "agnasdgn3r9n240unrfsdf")
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

          allow_any_instance_of(Api::V1::RecommendationsController).to receive(:current_user).and_return(user_3)

          get "/api/v1/recommendation", params: {auth_token: 'agnasdgn3r9n240unrfsdf'}

          expect(response.status).to eq(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_a Hash
          expect(result[:data][:id]).to eq(11423)
          expect(result[:data][:type]).to eq('cocktail')

          attributes = result[:data][:attributes]

          expect(attributes).to be_a Hash
          expect(attributes).to have_key :name
          expect(attributes[:name]).to eq('Godfather')

          expect(attributes).to have_key :thumbnail
          expect(attributes[:thumbnail]).to eq 'https://www.thecocktaildb.com/images/media/drink/e5zgao1582582378.jpg'

          expect(attributes).to have_key :glass
          expect(attributes[:glass]).to eq 'Old-fashioned glass'

          expect(attributes).to have_key :recipe
          expect(attributes[:recipe]).to eq(['1 1/2 oz Scotch','3/4 oz Amaretto'])

          expect(attributes).to have_key :instructions
          expect(attributes[:instructions]).to eq 'Pour all ingredients directly into old fashioned glass filled with ice cubes. Stir gently.'

          expect(attributes).to have_key :rating
          expect(attributes[:rating]).to eq(0)
        end    
      end
    end
  end

  describe 'GET /recommendation with randomness' do
    before :all do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
    end
    
    it 'provides a random cocktail if no similar (not identical) users exist' do
      response_body = File.read('./spec/fixtures/random_cocktail.json')
      stub_request(:any, "https://www.thecocktaildb.com/api/json/v1/1/random.php")
          .to_return(status: 200, body: response_body, headers: {})

      user_1 = create(:user, google_token: "agnasdgn3r9n240unrfs35253")

      cocktail_1 = create(:cocktail, name: 'margarita')
      cocktail_2 = create(:cocktail, name: 'old fashioned')
      cocktail_3 = create(:cocktail, name: 'whisky sour')

      create(:rating, user: user_1, cocktail: cocktail_1, stars: 1)
      create(:rating, user: user_1, cocktail: cocktail_2, stars: 1)
      create(:rating, user: user_1, cocktail: cocktail_3, stars: 5)

      get "/api/v1/recommendation", params: {auth_token: 'agnasdgn3r9n240unrfs35253'}

      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_a Hash
      expect(result[:data][:id]).not_to be_nil
      expect(result[:data][:type]).to eq('cocktail')

      attributes = result[:data][:attributes]

      expect(attributes).to be_a Hash
      expect(attributes).to have_key :id
      expect(attributes).to have_key :name
      expect(attributes).to have_key :thumbnail
      expect(attributes).to have_key :glass
      expect(attributes).to have_key :recipe
      expect(attributes).to have_key :instructions
      expect(attributes).to have_key :rating
      expect(attributes[:rating]).to eq(0)
    end
  end
end
