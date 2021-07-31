require 'rails_helper'

RSpec.describe CocktailService, :vcr do
  describe 'class methods' do
    VCR.use_cassette('cocktail drink', :record => :new_episodes) do

      describe '::get_cocktail_details' do
        it 'returns cocktail data' do
          manhattan = CocktailService.get_cocktail_details(11008)

          expect(manhattan).to be_a Hash
          expect(manhattan[:idDrink]).to be_a String
          expect(manhattan[:idDrink]).to eq('11008')

          expect(manhattan[:strDrink]).to be_a String
          expect(manhattan[:strDrink]).to eq('Manhattan')
          expect(manhattan[:strInstructions]).to be_a String
          expect(manhattan[:strInstructions]).to eq('Stirred over ice, strained into a chilled glass, garnished, and served up.')

          expect(manhattan[:strDrinkThumb]).to be_a String
          expect(manhattan[:strDrinkThumb]).to eq('https://www.thecocktaildb.com/images/media/drink/yk70e31606771240.jpg')

          expect(manhattan[:strIngredient1]).to be_a String
          expect(manhattan[:strIngredient1]).to eq('Sweet Vermouth')

          expect(manhattan[:strMeasure1]).to be_a String
          expect(manhattan[:strMeasure1]).to eq('3/4 oz ')
        end
      end
    end
  end
end
