require 'pycall/import'
include PyCall::Import

pyfrom :sklearn, import: :metrics
pyfrom 'sklearn.metrics', import: :pairwise
pyfrom 'sklearn.metrics.pairwise', import: :euclidean_distances

class RecommendationService
  def self.say_hello
    pandas = PyCall.import_module("pandas")
    numpy = PyCall.import_module("numpy")
    sklearn = PyCall.import_module("sklearn")
    csv_data = Pandas.read_csv("./db/data/cocktail_ratings.csv") #replace with our ratings data
    df = csv_data.set_index('name').fillna(0) #will likely be user_id instead of name
    # euclidean = Numpy.round(sklearn.metrics.pairwise.euclidean_distances(df,df),2)
    euclidean = Numpy.round(sklearn.metrics.pairwise.cosine_similarity(df,df),2)
    similar = Pandas.DataFrame.new(data=euclidean, index=df.index,columns=df.index)
    # sort true with Euclidean Distance
    max = similar.loc['Max'].sort_values(0,ascending=false)[1..5] #here, Max is replacing our USER_ID for the user requesting the rec
    df_max = Pandas.DataFrame.new(data=max, index=df.index)
    pivoted = Pandas.melt(df.reset_index(),id_vars='name',value_vars=df.keys)
    scraped_pivot = pivoted[pivoted.value != 0]
    new = df_max.reset_index()
    # total = new.merge(pivoted).dropna()
    total = new.merge(scraped_pivot).dropna()
    total['weightedRating']=total['Max']*total['value']
    similarity_weighted = total.groupby('variable').sum()[['Max','weightedRating']]
    empty = Pandas.DataFrame.new()
    empty['weightedAvgRecScore'] = similarity_weighted['Max']/similarity_weighted['weightedRating']
    # find an average rating by drink and multiply that by the 1/1+(ed)
    # find a weighted avg of the val column * the Max column
    # empty['variable'] = similarity_weighted.index
    empty.sort_values(by='weightedAvgRecScore', ascending=false)
    # empty.loc[empty['weightedAvgRecScore'].idxmax()]
    recommendation = empty[empty.weightedAvgRecScore == empty.weightedAvgRecScore.max()]
    binding.pry
  end
end
