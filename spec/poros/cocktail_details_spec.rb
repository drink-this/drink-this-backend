require 'rails_helper'

RSpec.describe CocktailDetails do
  describe '#initialize' do
    it 'abstracts and encapsulates cocktail data that be read' do
      details = {
        :name=>"Vodka Fizz",
       :thumbnail=>"https://www.thecocktaildb.com/images/media/drink/xwxyux1441254243.jpg",
       :glass=>"White wine glass",
       :recipe=>["2 oz Vodka", "2 oz Half-and-half", "2 oz Limeade", "Ice", "Nutmeg"],
       :instructions=>"Blend all ingredients, save nutmeg. Pour into large white wine glass and sprinkle nutmeg on top.",
       :rating=>4
      }

      vodka_fizz = CocktailDetails.new(details)

      expect(vodka_fizz.name).to eq('Vodka Fizz')
      expect(vodka_fizz.thumbnail).to eq('https://www.thecocktaildb.com/images/media/drink/xwxyux1441254243.jpg')
      expect(vodka_fizz.glass).to eq('White wine glass')
      expect(vodka_fizz.recipe).to eq(["2 oz Vodka", "2 oz Half-and-half", "2 oz Limeade", "Ice", "Nutmeg"])
      expect(vodka_fizz.instructions).to eq('Blend all ingredients, save nutmeg. Pour into large white wine glass and sprinkle nutmeg on top.')
      expect(vodka_fizz.rating).to eq(4)
    end
  end
end
