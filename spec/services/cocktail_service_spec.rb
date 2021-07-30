require 'rails_helper'

RSpec.describe CocktailService, :vcr do
  describe 'class methods' do
    VCR.use_cassette('cocktail drink', :record => :new_episodes) do

      describe '::get_cocktail_details' do
        it 'returns cocktail data' do
          manhattan = CocktailService.get_cocktail_details(11008)

          expect(manhattan).to be_a Hash
          expect(manhattan['drinks']).to be_an Array
          expect(manhattan['drinks'].first['idDrink']).to be_a String
          expect(manhattan['drinks'].first['strDrink']).to be_a String
          expect(manhattan['drinks'].first['strInstructions']).to be_a String
          expect(manhattan['drinks'].first['strIngredient1']).to be_a String
          expect(manhattan['drinks'].first['strMeasure1']).to be_a String
        end
      end
    end
  end
end
