module Dataframeable
  def self.create_df
    df = Pandas.DataFrame.new(data = Rating.prep_dataframe)
    df.columns=['user_id', 'cocktail_id', 'stars']
    df_pivot = df.pivot(index='user_id', columns='cocktail_id', values='stars').fillna(0)
  end
end
