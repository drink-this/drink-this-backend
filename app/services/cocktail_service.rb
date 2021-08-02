class CocktailService
  def self.get_cocktail_details(cocktail_id)
    response = Faraday.get('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?') do |req|
      req.params['i'] = cocktail_id
      req.params['api_key'] = ENV['cocktail_key']
    end

    parse_json(response)
  end

  def self.search_cocktails(query)
    response = Faraday.get('https://www.thecocktaildb.com/api/json/v1/1/search.php?') do |req|
      req.params['s'] = query
      req.params['api_key'] = ENV['cocktail_key']
    end

    parse_json(response)
  end

  # def self.conn
  #   Faraday.new(url: 'https://www.thecocktaildb.com/api/json/v1/1')
  # end

  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  # private_class_method :conn, :parse_json
end
