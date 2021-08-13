class CocktailFacade
  def self.retrieve_cocktail(user_id, cocktail_id)
    return false if retrieve_details(cocktail_id) == { drinks: nil }

    details = retrieve_details(cocktail_id)[:drinks].first
    ingredients = collect_from(details, 'Ingredient')
    measurements = collect_from(details, 'Measure')
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
    by_name = CocktailService.search_by_name(query)
    by_ingredient = CocktailService.search_by_ingredient(query)
    return false if by_name[:drinks].nil? && by_ingredient[:drinks].nil?

    search_results = merge_results(by_name, by_ingredient)
    search_results.map do |drink|
      {
        id: drink[:idDrink],
        name: drink[:strDrink],
        thumbnail: drink[:strDrinkThumb],
        rating: find_rating(user_id, drink[:idDrink])
      }
    end
  end

  def self.merge_results(by_name, by_ingredient)
    by_name[:drinks] = [] if by_name[:drinks].nil?
    by_ingredient[:drinks] = [] if by_ingredient[:drinks].nil?
    by_name[:drinks] += by_ingredient[:drinks]
  end

  def self.find_rating(user_id, cocktail_id)
    rating = Rating.find_by(user_id: user_id, cocktail_id: cocktail_id)
    return rating.stars if rating.present?

    0
  end

  def self.build_recipe(ingredients, measurements)
    measurements.zip(ingredients).map do |i|
      i.map { |str| str.strip }.join(' ').strip if i != ['', '']
    end.compact
  end

  def self.collect_from(cocktail_data, key_type)
    cocktail_data.map do |key, value|
      value ||= '' if key.to_s.include?(key_type)
    end.compact
  end
end
