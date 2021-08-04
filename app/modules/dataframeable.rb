module Dataframeable

  def self.create_df
    # all_three = Rating.all.select('user_id, cocktail_id, stars')

    # all_three_array = all_three.map do |three|
    #   [three.user_id, three.cocktail_id, three.stars]
    # end
    ratings = Rating.prep_dataframe

    df = Pandas.DataFrame.new(data = ratings)

    df.columns=['user_id', 'cocktail_id', 'stars']
    
    df_pivot = df.pivot(index='user_id', columns='cocktail_id', values='stars')

    df_pivot.fillna(0)
  end
end
