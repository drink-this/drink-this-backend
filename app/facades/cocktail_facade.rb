class CocktailFacade
  def self.retrieve_cocktail(user_id, cocktail_id)
    return false if retrieve_details(cocktail_id) == { drinks: nil }

    details = retrieve_details(cocktail_id)[:drinks].first
    ingredients = get_ingredients(details)
    measurements = get_measurements(details)
    {
      name: details[:strDrink],
      thumbnail: details[:strDrinkThumb],
      glass: details[:strGlass],
      recipe: build_recipe(ingredients, measurements),
      instructions: details[:strInstructions],
      rating: find_rating(user_id, cocktail_id)
    }
  end

  def self.retrieve_details(cocktail_id)
    if cocktail_id.present?
      CocktailService.get_cocktail_details(cocktail_id)
    else
      CocktailService.random_cocktail
    end
  end

  def self.retrieve_search_results(query, user_id)
    response = CocktailService.search_by_name(query)
    return false if response[:drinks].nil?

    response[:drinks].map do |drink|
      {
        id: drink[:idDrink],
        name: drink[:strDrink],
        thumbnail: drink[:strDrinkThumb],
        rating: find_rating(user_id, drink[:idDrink])
      }
    end
  end

  def self.find_rating(user_id, cocktail_id)
    rating = Rating.find_by(user_id: user_id, cocktail_id: cocktail_id)
    return rating.stars if rating.present?
    0
  end

  def self.build_recipe(ingredients, measurements)
    measurements.zip(ingredients).map do |i|
    i.map {|str| str.strip}.join(' ').strip if i != ['', '']
    end.compact
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
end
