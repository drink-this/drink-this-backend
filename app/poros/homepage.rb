class Homepage
  attr_reader :id

  def initialize(user, options = defaults)
    @id = nil
    @user = user
    options = defaults.merge(options)
    @glass_types = options[:glass_types]
    @alcohol_types = options[:alcohol_types]
  end

  def rated
    rated_cocktails = Cocktail.top_rated(@user.id)
    { cocktails: cocktail_basics(rated_cocktails) }
  end

  def unrated
    unrated_cocktails = Cocktail.sample_unrated(@user.id, 5)
    { cocktails: cocktail_basics(unrated_cocktails) }
  end

  def glass
    glass = @glass_types.sample
    cocktails = CocktailFacade.retrieve_by_glass(glass, @user.id).sample(5)
    { type: glass, cocktails: cocktails }
  end

  def alcohol
    alcohol = @alcohol_types.sample
    cocktails = CocktailFacade.retrieve_search_results(alcohol, @user.id).sample(5)
    { type: alcohol, cocktails: cocktails }
  end

  def cocktail_basics(cocktail_list)
    cocktail_list.map do |drink|
      {
        id: drink.id,
        name: drink.name,
        thumbnail: drink.thumbnail,
        rating: drink.rating
      }
    end
  end

  def defaults
    {
      glass_types: [
        'Collins Glass',
        'Highball glass',
        'Old-fashioned glass',
        'Champagne flute',
        'Pint glass',
        'Martini Glass'
      ],
      alcohol_types: ['Gin', 'Bourbon', 'Scotch', 'Rum', 'Tequila', 'Vodka']
    }
  end
end
