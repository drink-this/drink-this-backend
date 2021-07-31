require 'rails_helper'

RSpec.describe CocktailService, :vcr do
  describe 'class methods' do
    VCR.use_cassette('cocktail drink', :record => :new_episodes) do

      describe '::get_cocktail_details' do
        it 'returns cocktail data' do
          manhattan = CocktailService.get_cocktail_details(11008)

          expect(manhattan).to be_a Hash
          expect(manhattan['idDrink']).to be_a String
          expect(manhattan['strDrink']).to be_a String
          expect(manhattan['strInstructions']).to be_a String
          expect(manhattan['strDrinkThumb']).to be_a String
          expect(manhattan['strIngredient1']).to be_a String
          expect(manhattan['strMeasure1']).to be_a String
        end
      end
    end
  end
end
