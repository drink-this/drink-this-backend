class CocktailDetailsSerializer < ActiveModel::Serializer
  attributes :name, :thumbnail, :glass, :recipe, :instructions, :rating

  def self.details(cocktail)
    details = {
      data: {
        id: cocktail[:id].to_i,
        type: 'cocktail',
        attributes: cocktail
      }
    }
    details.to_json
  end
end
