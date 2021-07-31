require 'rails_helper'

RSpec.describe CocktailDetails do
  describe '::initialize' do
    it 'abstracts and encapsulates cocktail details' do
      manhattan_data = {
        "idDrink": "11008",
        "strDrink": "Manhattan",
        "strDrinkAlternate": nil,
        "strTags": "IBA,Classic,Alcoholic",
        "strVideo": "https://www.youtube.com/watch?v=TFWPtkNoF4Y",
        "strCategory": "Cocktail",
        "strIBA": "Unforgettables",
        "strAlcoholic": "Alcoholic",
        "strGlass": "Cocktail glass",
        "strInstructions": "Stirred over ice, strained into a chilled glass, garnished, and served up.",
        "strInstructionsES": nil,
        "strInstructionsDE": "Über Eis gerührt, in ein gekühltes Glas geseiht, garniert und serviert.",
        "strInstructionsFR": nil,
        "strInstructionsIT": "Mescolate su ghiaccio, filtrate in un bicchiere freddo, guarnite e servite.",
        "strInstructionsZH-HANS": nil,
        "strInstructionsZH-HANT": nil,
        "strDrinkThumb": "https://www.thecocktaildb.com/images/media/drink/yk70e31606771240.jpg",
        "strIngredient1": "Sweet Vermouth",
        "strIngredient2": "Bourbon",
        "strIngredient3": "Angostura bitters",
        "strIngredient4": "Ice",
        "strIngredient5": "Maraschino cherry",
        "strIngredient6": "Orange peel",
        "strIngredient7": nil,
        "strIngredient8": nil,
        "strIngredient9": nil,
        "strIngredient10": nil,
        "strIngredient11": nil,
        "strIngredient12": nil,
        "strIngredient13": nil,
        "strIngredient14": nil,
        "strIngredient15": nil,
        "strMeasure1": "3/4 oz ",
        "strMeasure2": "2 1/2 oz Blended ",
        "strMeasure3": "dash ",
        "strMeasure4": "2 or 3 ",
        "strMeasure5": "1 ",
        "strMeasure6": "1 twist of ",
        "strMeasure7": nil,
        "strMeasure8": nil,
        "strMeasure9": nil,
        "strMeasure10": nil,
        "strMeasure11": nil,
        "strMeasure12": nil,
        "strMeasure13": nil,
        "strMeasure14": nil,
        "strMeasure15": nil,
        "strImageSource": "https://commons.wikimedia.org/wiki/File:Oak_Fired_Manhattan_-_Stierch_1.jpg",
        "strImageAttribution": "Sarah Stierch (CC BY 4.0)",
        "strCreativeCommonsConfirmed": "Yes",
        "dateModified": "2017-09-02 12:07:09"
        }

      manhattan = CocktailDetails.new(manhattan_data)

      expect(manhattan.id).to eq('11008')
      expect(manhattan.name).to eq('Manhattan')
      expect(manhattan.instructions).to eq('Stirred over ice, strained into a chilled glass, garnished, and served up.')
      expect(manhattan.thumbnail).to eq('https://www.thecocktaildb.com/images/media/drink/yk70e31606771240.jpg')

      manhattan_ingredients = ["Sweet Vermouth", "Bourbon", "Angostura bitters", "Ice", "Maraschino cherry", "Orange peel"]

      expect(manhattan.ingredients).to eq(manhattan_ingredients)

      manhattan_measurements = ["3/4 oz ", "2 1/2 oz Blended ", "dash ", "2 or 3 ", "1 ", "1 twist of "]

      expect(manhattan.measurements).to eq(manhattan_measurements)
    end
  end
end
