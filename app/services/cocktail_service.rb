class CocktailService
  def self.get_cocktail_details(cocktail_id)
    response = Faraday.get('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?') do |req|
      req.params['i'] = cocktail_id
      req.params['api_key'] = ENV['cocktail_key']
    end

    parse_json(response)
  end

  private

  def self.parse_json(response)
    JSON.parse(response.body, sybmolize_names: true)
  end
end
