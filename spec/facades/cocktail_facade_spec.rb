require 'rails_helper'

RSpec.describe CocktailFacade, :vcr do
  VCR.use_cassette('cocktail drink', :record => :new_episodes) do
    describe '::retrieve_cocktail' do
      before :each do
        User.destroy_all
        Cocktail.destroy_all
        Rating.destroy_all
      end

      it 'returns json with cocktail details and rating' do
        vodka_fizz = CocktailFacade.retrieve_cocktail('16967')

        expect(vodka_fizz).to have_key :name
        expect(vodka_fizz[:name]).to eq('Vodka Fizz')

        expect(vodka_fizz).to have_key :thumbnail
        expect(vodka_fizz[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/xwxyux1441254243.jpg')

        expect(vodka_fizz).to have_key :glass
        expect(vodka_fizz[:glass]).to eq('White wine glass')

        expect(vodka_fizz).to have_key :recipe
        expect(vodka_fizz[:recipe]).to be_an Array
        expect(vodka_fizz[:recipe].length).to eq(5)
        expect(vodka_fizz[:recipe].first).to eq('2 oz Vodka')
        expect(vodka_fizz[:recipe].last).to eq('Nutmeg')

        expect(vodka_fizz).to have_key :instructions
        expect(vodka_fizz[:instructions]).to eq('Blend all ingredients, save nutmeg. Pour into large white wine glass and sprinkle nutmeg on top.')

        expect(vodka_fizz).to have_key :rating
        expect(vodka_fizz[:rating]).to eq(0)
      end

      it 'returns rating if present' do
        user = create(:user)
        create(:cocktail, id: 16967)
        create(:rating, cocktail_id: 16967, user_id: user.id, stars: 4)
        vodka_fizz = CocktailFacade.retrieve_cocktail('16967')

        expect(vodka_fizz[:rating]).to eq(4)
      end
    end
  end

  VCR.use_cassette('cocktail search', :record => :new_episodes) do
    describe '::retrieve_search_results' do
      before :each do
        User.destroy_all
        Cocktail.destroy_all
        Rating.destroy_all
      end

      it 'returns json with list of cocktails by query' do
        user = create(:user)
        create(:cocktail, id: 11324)
        create(:cocktail, id: 11005)
        create(:rating, cocktail_id: 11324, user_id: user.id, stars: 4)
        create(:rating, cocktail_id: 11005)

        dry = CocktailFacade.retrieve_search_results('dry', user.id)

        expect(dry).to be_an Array

        result_1 = dry.first

        expect(result_1).to be_a Hash
        expect(result_1[:name]).to eq('Dry Rob Roy')
        expect(result_1[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/typuyq1439456976.jpg')
        expect(result_1[:rating]).to eq(4)

        result_2 = dry.second

        expect(result_2).to be_a Hash
        expect(result_2[:name]).to eq('Dry Martini')
        expect(result_2[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/6ck9yi1589574317.jpg')
        expect(result_2[:rating]).to eq(0)
      end
    end
  end
end
