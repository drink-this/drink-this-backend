require 'rails_helper'

RSpec.describe CocktailService, :vcr do
  describe 'class methods' do
    VCR.use_cassette('cocktail drink', :record => :new_episodes) do
      describe '::get_cocktail_details' do
        it 'returns cocktail data' do
          response = CocktailService.get_cocktail_details(11008)

          expect(response).to be_a Hash
          expect(response[:drinks]).to be_an Array

          manhattan = response[:drinks].first

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

    describe '::random_cocktail' do
      it 'returns data for a random cocktail' do
        response = CocktailService.random_cocktail

        expect(response).to be_a Hash
        expect(response[:drinks]).to be_an Array

        cocktail = response[:drinks].first

        expect(cocktail[:idDrink]).to be_a String
        expect(cocktail[:strDrink]).to be_a String
        expect(cocktail[:strInstructions]).to be_a String
        expect(cocktail[:strDrinkThumb]).to be_a String
        expect(cocktail[:strIngredient1]).to be_a String
        expect(cocktail[:strMeasure1]).to be_a String
      end
    end

    VCR.use_cassette('cocktail search', :record => :new_episodes) do
      describe '::search_cocktails' do
        it 'returns search results' do
          response = CocktailService.search_cocktails('vodka')

          expect(response).to be_a Hash
          expect(response[:drinks]).to be_an Array

          long_vodka = response[:drinks].first

          expect(long_vodka).to be_a Hash
          expect(long_vodka[:idDrink]).to eq('13196')
          expect(long_vodka[:strDrink]).to eq('Long vodka')
          expect(long_vodka[:strDrinkThumb]).to eq('https://www.thecocktaildb.com/images/media/drink/9179i01503565212.jpg')

          vodka_and_tonic = response[:drinks].second

          expect(vodka_and_tonic).to be_a Hash
          expect(vodka_and_tonic[:idDrink]).to eq('16967')
          expect(vodka_and_tonic[:strDrink]).to eq('Vodka Fizz')
          expect(vodka_and_tonic[:strDrinkThumb]).to eq('https://www.thecocktaildb.com/images/media/drink/xwxyux1441254243.jpg')
        end
      end
    end

    describe '::search_by_ingredient', :vcr do
      it 'returns search results' do
        response = CocktailService.search_by_ingredient('Green Chartreuse')

        expect(response).to be_a Hash
        expect(response[:drinks]).to be_an Array

        bijou = response[:drinks].first

        expect(bijou).to be_a Hash
        expect(bijou[:idDrink]).to eq('17254')
        expect(bijou[:strDrink]).to eq('Bijou')
        expect(bijou[:strDrinkThumb]).to eq('https://www.thecocktaildb.com/images/media/drink/rysb3r1513706985.jpg')

        brigadier = response[:drinks].second

        expect(brigadier).to be_a Hash
        expect(brigadier[:idDrink]).to eq('17825')
        expect(brigadier[:strDrink]).to eq('Brigadier')
        expect(brigadier[:strDrinkThumb]).to eq('https://www.thecocktaildb.com/images/media/drink/nl89tf1518947401.jpg')
      end
    end
  end
end
