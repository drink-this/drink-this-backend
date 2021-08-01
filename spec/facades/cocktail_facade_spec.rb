require 'rails_helper'

RSpec.describe CocktailFacade, :vcr do
  VCR.use_cassette('cocktail drink', :record => :new_episodes) do
    describe '#retrieve_cocktail' do
      before :each do
        Cocktail.destroy_all
        User.destroy_all
        Rating.destroy_all
      end

      it 'returns json with cocktail details' do
        vodka_fizz = CocktailFacade.retrieve_cocktail('16967')

        expect(vodka_fizz).to be_a CocktailDetails
        expect(vodka_fizz.name).to eq('Vodka Fizz')
        expect(vodka_fizz.thumbnail).to eq('https://www.thecocktaildb.com/images/media/drink/xwxyux1441254243.jpg')
        expect(vodka_fizz.glass).to eq('White wine glass')
        expect(vodka_fizz.recipe).to be_an Array
        expect(vodka_fizz.recipe).to eq(["2 oz Vodka", "2 oz Half-and-half", "2 oz Limeade", "Ice", "Nutmeg"])
        expect(vodka_fizz.instructions).to eq('Blend all ingredients, save nutmeg. Pour into large white wine glass and sprinkle nutmeg on top.')
        expect(vodka_fizz.rating).to eq(0)
      end

      it 'returns rating if present' do
        create(:cocktail, id: 16967)
        user = create(:user)
        create(:rating, cocktail_id: 16967, user_id: user.id, stars: 4)
        vodka_fizz = CocktailFacade.retrieve_cocktail('16967')

        expect(vodka_fizz.rating).to eq(4)
      end
    end
  end
end
