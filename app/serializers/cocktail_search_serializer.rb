class CocktailSearchSerializer < ActiveModel::Serializer
  attributes :name, :thumbnail, :rating

  def self.search_list(query)
    if query.is_a?(Hash)
      {
        data: query
      }
    else
      {
        data:
          query.map do |cocktail_result|
            {
              id: cocktail_result[:id],
              type: 'cocktails_search',
              attributes: {
                name: cocktail_result[:name],
                thumbnail: cocktail_result[:thumbnail],
                rating: cocktail_result[:rating]
              }
            }
          end
      }.to_json
    end
  end
end
