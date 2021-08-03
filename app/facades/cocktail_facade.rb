class CocktailFacade
  def self.retrieve_cocktail(cocktail_id)
    response = CocktailService.get_cocktail_details(cocktail_id)

    details = response[:drinks].first

    ingredients = get_ingredients(details)
    measurements = get_measurements(details)

    recipe = measurements.zip(ingredients).map do |i|
      i.join if i != ['', '']
    end.compact

    rating = if Rating.find_by(cocktail_id: cocktail_id).present?
               Rating.find_by(cocktail_id: cocktail_id).stars
             else
               0
             end

    {
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
    cocktail_data.map do |key, value|
      value ||= '' if key.to_s.include?('Ingredient')
    end.compact
  end

  def self.get_measurements(cocktail_data)
    cocktail_data.map do |key, value|
      value ||= '' if key.to_s.include?('Measure')
    end.compact
  end

  def self.retrieve_search_results(query, user_id)
    response = CocktailService.search_cocktails(query)

    response[:drinks].map do |drink|
      {
        id: drink[:idDrink],
        name: drink[:strDrink],
        thumbnail: drink[:strDrinkThumb],
        rating: if Rating.find_by(cocktail_id: drink[:idDrink], user_id: user_id).present?
                  Rating.find_by(cocktail_id: drink[:idDrink], user_id: user_id).stars
                else
                  0
                end
      }
    end
  end
end
