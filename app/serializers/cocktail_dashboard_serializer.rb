class CocktailDashboardSerializer < ActiveModel::Serializer
  attributes :name, :thumbnail, :rating

  def self.details(cocktails)
    {
      data:
        cocktails.map do |cocktail|
          {
            id: cocktail.id,
            type: 'dashboard_cocktail',
            attributes: {
              name: cocktail[:name],
              thumbnail: cocktail[:thumbnail],
              rating: cocktail[:rating]
            }
          }
        end
    }.to_json
  end
end
