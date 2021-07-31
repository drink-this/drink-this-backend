class CocktailDetails
  attr_reader :id, :name, :instructions, :thumbnail, :ingredients, :measurements

  def initialize(cocktail_data)
    @id = cocktail_data[:idDrink]
    @name = cocktail_data[:strDrink]
    @instructions = cocktail_data[:strInstructions]
    @thumbnail = cocktail_data[:strDrinkThumb]
    @ingredients = get_ingredients(cocktail_data)
    @measurements = get_measurements(cocktail_data)
  end

  def get_ingredients(cocktail_data)
    ingredients = []
    cocktail_data.each do |key, value|
      stringify_key = key.to_s
      if stringify_key.include?("Ingredient") && value != nil
        ingredients << value
      end
    end
    ingredients
  end

  def get_measurements(cocktail_data)
    measurements = []
    cocktail_data.each do |key, value|
      stringify_key = key.to_s
      if stringify_key.include?("Measure") && value != nil
        measurements << value
      end
    end
    measurements
  end
end
