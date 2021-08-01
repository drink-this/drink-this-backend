class CocktailFacade
  def self.retrieve_cocktail(cocktail_id)
    response = CocktailService.get_cocktail_details(cocktail_id)

    details = response[:drinks].first

    ingredients = get_ingredients(details)
    measurements = get_measurements(details)

    recipe = measurements.zip(ingredients).map do |i|
      i.join if i != ["", ""]
    end.compact

    rating = if Rating.find_by(cocktail_id: cocktail_id).present?
      Rating.find_by(cocktail_id: cocktail_id).stars
    else
      0
    end

    cocktail = {
      # id: details[:idDrink],
      name: details[:strDrink],
      thumbnail: details[:strDrinkThumb],
      glass: details[:strGlass],
      recipe: recipe,
      instructions: details[:strInstructions],
      rating: rating
    }

    # CocktailDetails.new(cocktail)
  end

  def self.get_ingredients(cocktail_data)
    ingredients = []
    cocktail_data.each do |key, value|
      stringify_key = key.to_s
      if stringify_key.include?("Ingredient")
        value = "" if value.nil?
        ingredients << value
      end
    end
    ingredients
  end

  def self.get_measurements(cocktail_data)
    measurements = []
    cocktail_data.each do |key, value|
      stringify_key = key.to_s
      if stringify_key.include?("Measure")
        value = "" if value.nil?
        measurements << value
      end
    end
    measurements
  end
end
