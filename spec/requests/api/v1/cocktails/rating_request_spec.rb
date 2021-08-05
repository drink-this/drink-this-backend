require 'rails_helper'

RSpec.describe 'Rating API' do
  describe 'show response endpoint' do
    before :all do
      User.destroy_all
      Cocktail.destroy_all
      @cocktail_1 = create(:cocktail)
      @user_1 = create(:user, google_token: 'BBBasdsgergn240unrfs35253')

      @cocktail_2 = create(:cocktail, id: 16967)
      @user_2 = create(:user, google_token: 'agnasdgn3r9n240unrfsdf')
      create(:rating, cocktail_id: @cocktail_2.id, user_id: @user_2.id, stars: 2)
    end

    context 'the cocktail exists in our database' do
      it 'can send rating of a specific cocktail' do
        post "/api/v1/cocktails/#{@cocktail_1.id}/rating/", params: {
          auth_token: 'BBBasdsgergn240unrfs35253',
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

      it 'request must have stars param' do
        post "/api/v1/cocktails/#{@cocktail_1.id}/rating", params: { auth_token: 'BBBasdsgergn240unrfs35253' }

        expect(response.status).to eq(400)
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:error]).to eq("Failed to create resource")
        expect(response_body[:messages].first).to eq("Stars can't be blank")
      end

      it 'request must have auth_token param' do
        post "/api/v1/cocktails/#{@cocktail_1.id}/rating", params: { stars: 3 }

        expect(response.status).to eq(404)
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:error]).to eq("Couldn't find User")
      end

      it 'request must have stars as an integer' do
        post "/api/v1/cocktails/#{@cocktail_1.id}/rating", params: {
          auth_token: 'BBBasdsgergn240unrfs35253',
          stars: "three"
        }

        expect(response.status).to eq(400)
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:error]).to eq("Failed to create resource")
        expect(response_body[:messages].first).to eq("Stars is not a number")
      end
    end

    context 'the cocktail does not yet exist in our database' do
      it 'creates the cocktail in the database and adds the rating as well', :vcr do
        post "/api/v1/cocktails/11423/rating/", params: {
          auth_token: 'BBBasdsgergn240unrfs35253',
          stars: 3
        }

        expect(response.status).to eq(201)

        cocktail_1_rating = JSON.parse(response.body, symbolize_names: true)

        new_cocktail = Cocktail.find(cocktail_1_rating[:data][:attributes][:cocktail_id])
        expect(new_cocktail).to be_a Cocktail

        rating = Rating.find(cocktail_1_rating[:data][:id])
        expect(rating).to be_a Rating

        expect(rating.stars).to eq 3
      end

      it 'returns error if cocktail not found by the API', :vcr do
        post "/api/v1/cocktails/912480267934824/rating", params: {
          auth_token: 'BBBasdsgergn240unrfs35253',
          stars: 3
        }

        expect(response.status).to eq(400)
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:error]).to eq("Failed to create resource")
        expect(response_body[:messages].first).to eq("Cocktail must exist")
      end
    end

    context 'the rating of a cocktail exists and is updated' do
      it 'checks that cocktail and rating of cocktail by user exists' do
        rating = Rating.find_by(user_id: @user_2.id, cocktail_id: @cocktail_2.id)

        expect(rating.stars).to eq(2)

        previous_rating = rating.stars

        post "/api/v1/cocktails/#{@cocktail_2.id}/rating/", params: {
          auth_token: 'agnasdgn3r9n240unrfsdf',
          stars: 5
        }

        expect(response.status).to eq(201)

        cocktail_2_rating = JSON.parse(response.body, symbolize_names: true)
        new_rating = Rating.find(cocktail_2_rating[:data][:id])

        expect(cocktail_2_rating).to have_key(:data)
        expect(cocktail_2_rating[:data]).to be_a Hash

        expect(cocktail_2_rating[:data][:type]).to eq("cocktail_rating")
        expect(cocktail_2_rating[:data][:attributes][:user_id]).to eq(new_rating.user_id)
        expect(cocktail_2_rating[:data][:attributes][:cocktail_id]).to eq(new_rating.cocktail_id)
        expect(cocktail_2_rating[:data][:attributes][:stars]).to eq(new_rating.stars)

        expect(cocktail_2_rating[:data][:attributes][:stars]).to_not eq(previous_rating)
      end
    end
  end
end
