require 'rails_helper'

RSpec.describe 'Cocktail Details API', :vcr do
  VCR.use_cassette('cocktail drink', :record => :new_episodes) do
    describe 'show response endpoint' do
      before :all do
        User.destroy_all
        Cocktail.destroy_all
        Rating.destroy_all
        @cocktail_1 = create(:cocktail, id: 16967)
        @user_1 = create(:user)
        @user_2 = create(:user)
        create(:rating, cocktail_id: @cocktail_1.id, user_id: @user_1.id, stars: 4)
      end

      it 'send json of cocktail details via get request' do
        get "/api/v1/cocktails/#{@cocktail_1.id}", params: {
          user_id: @user_1.id
        }

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

      it '(sad path) send json error when no params with user id' do
        get "/api/v1/cocktails/#{@cocktail_1.id}", params: { }

        expect(response.status).to eq(200)

        result = JSON.parse(response.body, symbolize_names: true)

        expect(result[:error]).to eq('User error.')
      end

      it '(sad path) send json error when no params with user id' do
        get "/api/v1/cocktails/#{@cocktail_1.id}", params: {
          user_id: @user_2.id
        }

        expect(response.status).to eq(200)

        result = JSON.parse(response.body, symbolize_names: true)

        expect(result[:error]).to eq('User error.')
      end

      it '(sad path) send json error when there is an incorrect cocktail id' do
        get "/api/v1/cocktails/38293", params: {
          user_id: @user_1.id
        }

        expect(response.status).to eq(200)

        result = JSON.parse(response.body, symbolize_names: true)

        expect(result[:error]).to eq('User error.')
      end
    end
  end
end
