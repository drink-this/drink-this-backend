class YelpFacade
  def self.search_nearby(cocktail, location)
    results = YelpService.get_businesses(cocktail, location)
    results.map do |result|
      Business.create(result)
    end
  end
end
