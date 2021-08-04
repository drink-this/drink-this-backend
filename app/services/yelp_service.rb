class YelpService
  def self.get_businesses(cocktail, location)
    response = conn.get("businesses/search?term=#{cocktail}&location=#{location}&limit=10&categories=bars")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://api.yelp.com/v3/') do |faraday|
      faraday.headers['Authorization'] = "Bearer #{ENV['YELP_KEY']}"
    end
  end

  private_class_method :conn
end
