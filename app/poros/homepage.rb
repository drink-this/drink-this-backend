class Homepage
  def initialize(user, options = defaults)
    @user = user
    @glass_types = options[:glass_type]
    @alcohol_types = options[:alcohol_type]
  end

  def rated
    { cocktails: @user.cocktails.sample_rated(5) }
  end

  def unrated
    { cocktails: @user.cocktails.sample_unrated(5) }
  end

  def glass
    glass = @glass_types.sample
    cocktails = CocktailFacade.search_by_glass(glass, @user.id).sample(5)
    { type: glass, cocktails: cocktails}
  end

  def alcohol
    alcohol = @alcohol_types.sample
    cocktails = CocktailFacade.search_by_ingredient(alcohol, @user.id).sample(5)
    { type: alcohol, cocktails: cocktails}
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
      alcohol_types: ['Gin', 'Bourbon', 'Scotch', 'Rum', 'Tequila']
    }
  end
end
