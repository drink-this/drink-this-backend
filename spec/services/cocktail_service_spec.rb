require 'rails_helper'

RSpec.describe CocktailService, :vcr do
  describe 'class methods' do
    describe '::get_cocktail_details' do
      it 'returns cocktail data', :vcr do
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

      it 'returns an empty array if no cocktail exists', :vcr do
        response = CocktailService.get_cocktail_details(258134685-83468934)

        expect(response).to be_a Hash
        expect(response[:drinks]).to be nil
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


    describe '::search_by_name' do
      it 'returns search results', :vcr do
        response = CocktailService.search_by_name('vodka')

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

      it 'returns nil if no results are found', :vcr do
        response = CocktailService.search_by_name('Green Chartreuse')

        expect(response).to be_a Hash
        expect(response[:drinks]).to be nil
      end
    end

    describe '::search_by_ingredient' do
      it 'returns search results', :vcr do
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

      it 'returns nil if no results are found', :vcr do
        response = CocktailService.search_by_ingredient('dry')

        expect(response).to be_a Hash
        expect(response[:drinks]).to be nil
      end
    end

    describe '::search_by_glass' do
      it 'returns search results for given glass type', :vcr do
        response = CocktailService.search_by_glass('Collins glass')

        expect(response).to be_a Hash
        expect(response[:drinks]).to be_an Array

        wise_men = response[:drinks].first

        expect(wise_men).to be_a Hash
        expect(wise_men[:idDrink]).to eq('13899')
        expect(wise_men[:strDrink]).to eq('3 Wise Men')
        expect(wise_men[:strDrinkThumb]).to eq('https://www.thecocktaildb.com/images/media/drink/wxqpyw1468877677.jpg')

        long_island = response[:drinks].second

        expect(long_island).to be_a Hash
        expect(long_island[:idDrink]).to eq('15300')
        expect(long_island[:strDrink]).to eq('3-Mile Long Island Iced Tea')
        expect(long_island[:strDrinkThumb]).to eq('https://www.thecocktaildb.com/images/media/drink/rrtssw1472668972.jpg')
      end

      it 'returns nil if no results are found', :vcr do
        response = CocktailService.search_by_glass('rocks')

        expect(response).to be_a Hash
        expect(response[:drinks]).to be nil
      end
    end
  end
end
