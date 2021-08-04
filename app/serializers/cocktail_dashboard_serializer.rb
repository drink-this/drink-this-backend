class CocktailDashboardSerializer < ActiveModel::Serializer
  attributes :name, :thumbnail, :rating

  def self.details(cocktails)
    {
      data:
        cocktails.map do |cocktail|
          {
            attributes: {
              name: cocktail[:name],
              thumbnail: cocktail[:thumbnail],
            }
          }
        end
    }.to_json
  end
end
