require 'rails_helper'

RSpec.describe 'Cocktail Search API' do
  describe 'show response endpoint' do
    before :all do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
      @cocktail_1 = create(:cocktail, id: 16967)
      @user_1 = create(:user)
      create(:rating, cocktail_id: @cocktail_1.id, user_id: @user_1.id, stars: 4)
    end

    it 'send json of cocktail list via get request' do
      get "/api/v1/cocktails/search", params: {
        name: "margarita"
      }

    end
  end
end
