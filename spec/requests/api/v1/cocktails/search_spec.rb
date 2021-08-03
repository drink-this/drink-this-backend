require 'rails_helper'

RSpec.describe 'Cocktail Search API', :vcr do
  VCR.use_cassette('cocktail search', :record => :new_episodes) do
    describe 'show response endpoint' do
      before :all do
        User.destroy_all
        Cocktail.destroy_all
        Rating.destroy_all
        @user = create(:user, google_token: 'agnasdgn3r9n240unrfsdf')
        @user_2 = create(:user)
        @cocktail_1 = create(:cocktail, id: 11324)
        @cocktail_2 = create(:cocktail, id: 11005)
        @cocktail_3 = create(:cocktail, id: 16967)
        create(:rating, cocktail_id: 11324, user_id: @user.id, stars: 4)
        create(:rating, cocktail_id: 11005)
        create(:rating, cocktail_id: 16967, user_id: @user.id, stars: 2)

        create(:rating, cocktail_id: @cocktail_1.id, user_id: @user.id, stars: 4)
        create(:rating, cocktail_id: @cocktail_2.id)
      end

      it 'send json of cocktail list via get request' do
        get "/api/v1/cocktails/search", params: {
          search: 'dry',
          auth_token: 'agnasdgn3r9n240unrfsdf'
        }

        expect(response.status).to eq(200)

        search_results = JSON.parse(response.body, symbolize_names: true)

        expect(search_results[:data]).to be_an Array

        first_result = search_results[:data].first

        expect(first_result[:id]).to eq(@cocktail_1.id.to_s)
        expect(first_result[:type]).to eq('cocktails_search')
        expect(first_result[:attributes]).to be_a Hash
        expect(first_result[:attributes]).to have_key :name
        expect(first_result[:attributes]).to have_key :thumbnail
        expect(first_result[:attributes]).to have_key :rating
        expect(first_result[:attributes][:rating]).to eq(4)

        second_result = search_results[:data].second

        expect(second_result[:attributes][:rating]).to eq(0)

        expect(search_results[:data].third).to eq(nil)
      end

      it '(sad path) sends error message when blank search query' do
        get "/api/v1/cocktails/search", params: {
          search: '',
          auth_token: 'agnasdgn3r9n240unrfsdf'
        }

        expect(response.status).to eq(404)

        search_results = JSON.parse(response.body, symbolize_names: true)

        expect(search_results[:errors]).to eq("Couldn't find Cocktail")
      end

      it '(sad path) sends error message when search query is gibberish' do
        get "/api/v1/cocktails/search", params: {
          search: 'sdkljfs',
          auth_token: 'agnasdgn3r9n240unrfsdf'
        }

        expect(response.status).to eq(404)

        search_results = JSON.parse(response.body, symbolize_names: true)

        expect(search_results[:errors]).to eq("Couldn't find Cocktail")
      end

      it '(sad path) sends error when user is not in params' do
        get "/api/v1/cocktails/search", params: {
          search: 'dry'
        }

        expect(response.status).to eq(404)

        search_results = JSON.parse(response.body, symbolize_names: true)

        expect(search_results[:errors]).to eq("Couldn't find User")
      end

      it '(sad path) sends error when user is incorrect' do
        get "/api/v1/cocktails/search", params: {
          search: 'dry',
          auth_token: 'slklkekspwpmemslld32'
        }

        expect(response.status).to eq(404)

        search_results = JSON.parse(response.body, symbolize_names: true)

        expect(search_results[:errors]).to eq("Couldn't find User")
      end
    end
  end
end
