require 'rails_helper'

RSpec.describe 'Cocktail Dashboard API' do
  describe 'show response endpoint' do
    before :each do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all

      @user = create(:user, google_token: 'agnasdgn3r9n240unrfsdf')
      @user_2 = create(:user)

      @cocktail_1 = create(:cocktail, id: 11324)
      @cocktail_2 = create(:cocktail, id: 11005)
      @cocktail_4 = create(:cocktail, id: 11408)
      @cocktail_5 = create(:cocktail, id: 11415)
      @cocktail_6 = create(:cocktail, id: 11419)
      @cocktail_7 = create(:cocktail, id: 17197)
      @cocktail_8 = create(:cocktail, id: 11382)
      @cocktail_9 = create(:cocktail, id: 15427)
      @cocktail_10 = create(:cocktail, id: 17230)
      @cocktail_11 = create(:cocktail, id: 11410)
      @cocktail_12 = create(:cocktail, id: 13070)

    end

    it 'sends 5 random cocktails via get request', :vcr do
      get "/api/v1/dashboard", params: {
        auth_token: 'agnasdgn3r9n240unrfsdf'
      }

      expect(response.status).to eq(200)

      cocktails = JSON.parse(response.body, symbolize_names: true)

      expect(cocktails[:data]).to be_an(Array)
      expect(cocktails[:data].count).to eq(5)

      first_result = cocktails[:data].first

      expect(first_result[:attributes]).to have_key :name
      expect(first_result[:attributes]).to have_key :thumbnail
      expect(first_result[:attributes]).to have_key :rating
    end
  end
end
