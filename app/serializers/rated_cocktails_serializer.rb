class RatedCocktailsSerializer

  def self.serialize(rated_cocktails)
    {
      data: {
        type: 'rated_cocktails',
        id: nil,
        attributes: 
          rated_cocktails.map do |rc|
            {
              id: rc.id,
              name: rc.name,
              thumbnail: rc.thumbnail,
              stars: rc.stars
            }
          end
      }
    }
  end
end