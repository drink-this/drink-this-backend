class CocktailDetails
  attr_reader :id, :name, :thumbnail, :glass, :recipe, :instructions, :rating

  def initialize(cocktail_details)
    @id = cocktail_details[:id]
    @name = cocktail_details[:name]
    @thumbnail = cocktail_details[:thumbnail]
    @glass = cocktail_details[:glass]
    @recipe = cocktail_details[:recipe]
    @instructions = cocktail_details[:instructions]
    @rating = cocktail_details[:rating]
  end
end
