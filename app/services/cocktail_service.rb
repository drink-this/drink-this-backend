class CocktailService
  def self.get_cocktail_details(cocktail_id)
    response = conn.get('lookup.php?', { i: cocktail_id })
    parse_json(response)
  end

  def self.random_cocktail
    response = conn.get('random.php')
    parse_json(response)
  end

  def self.search_by_name(query)
    response = conn.get('search.php?', { s: query })
    parse_json(response)
  end

  def self.search_by_ingredient(ingredient)
    response = conn.get('filter.php?', { i: ingredient })
    return parse_json(response) if response.body.present?

    { drinks: nil }
  end

  def self.conn
    Faraday.new(url: 'https://www.thecocktaildb.com/api/json/v1/1/') do |req|
      req.params['api_key'] = ENV['cocktail_key']
    end
  end

  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  private_class_method :conn, :parse_json
end
