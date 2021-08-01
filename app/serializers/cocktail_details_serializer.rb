class CocktailDetailsSerializer < ActiveModel::Serializer
  attributes :name, :thumbnail, :glass, :recipe, :instructions, :rating

  def self.details(id, cocktail)
    details = {
      data: {
        id: id,
        type: 'cocktail',
        attributes: cocktail
      }
    }
    details.to_json
  end
end
