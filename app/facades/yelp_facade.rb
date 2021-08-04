class YelpFacade
  def self.search_nearby(cocktail, location)
    results = YelpService.get_businesses(cocktail, location)[:businesses]
    results.map do |result|
      Business.new(result)
    end
  end
end
