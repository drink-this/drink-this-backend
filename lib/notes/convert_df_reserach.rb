all_three = Rating.all.select('user_id, cocktail_id, stars')

all_three_array = all_three.map do |three|
  [three.user_id, three.cocktail_id, three.stars]
end

df = Pandas.DataFrame.new(data = all_three_array)

df.columns=['user_id', 'cocktail_id', 'stars']

df_pivot = df.pivot(index='user_id', columns='cocktail_id', values='stars')

# df_index = df.set_index('user_id')

# df_index = df.set_index(df[0])
# df_index_drop = df_index.drop(df_index.columns[[0]], axis=1)
# returned this warning => sys:1: FutureWarning: In a future version of pandas all arguments of DataFrame.drop except for the argument 'labels' will be keyword-only
