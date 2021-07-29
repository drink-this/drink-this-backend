require 'pycall/import'
include PyCall::Import

pyimport :pandas
pyfrom :sklearn, import: :metrics
pyfrom 'sklearn.metrics', import: :pairwise
pyfrom 'sklearn.metrics.pairwise', import: :euclidean_distances

class RecommendationService
  def self.say_hello
    # import all the libraries we need
    # pandas = PyCall.import_module("pandas")
    numpy = PyCall.import_module("numpy")
    sklearn = PyCall.import_module("sklearn")

    csv_data = Pandas.read_csv("./db/data/cocktail_ratings.csv") #replace with our ratings data
    df = csv_data.set_index('name').fillna(0) #will likely be user_id instead of name

    euclidean = Numpy.round(sklearn.metrics.pairwise.euclidean_distances(df,df),2)
    # euclidean = Numpy.round(sklearn.metrics.pairwise.cosine_similarity(df,df),2)

    similar = Pandas.DataFrame.new(data=euclidean, index=df.index,columns=df.index)
    
    # sort true with Euclidean Distance, false with cosine similarity
    max = similar.loc['Max'].sort_values(0,ascending=true)[1..5] #here, Max is replacing our USER_ID for the user requesting the rec
    # max = similar.loc['Max'].sort_values(0,ascending=false)[1..5] #here, Max is replacing our USER_ID for the user requesting the rec

    df_max = Pandas.DataFrame.new(data=max, index=df.index)

    pivoted = Pandas.melt(df.reset_index(),id_vars='name',value_vars=df.keys)
    scraped_pivot = pivoted[pivoted.value != 0]

    new = df_max.reset_index()
    total = new.merge(scraped_pivot).dropna()

    total['weightedRating']=(1 / total['Max']+1)*total['value']
    # total['weightedRating']=total['Max']*total['value']

    similarity_weighted = total.groupby('variable').sum()[['Max','weightedRating']]
    
    max_pivot = pivoted[pivoted.name == 'Max']
    
    reset_sw = similarity_weighted.reset_index()
    unknown_to_user = reset_sw.merge(max_pivot).set_index('variable')
    unknown_to_user = unknown_to_user[unknown_to_user.value == 0]

    empty = Pandas.DataFrame.new()
    empty['weightedAvgRecScore'] = unknown_to_user['Max']/unknown_to_user['weightedRating']

    # empty.loc[empty['weightedAvgRecScore'].idxmax()]
    recommendation = empty[empty.weightedAvgRecScore == empty.weightedAvgRecScore.max()]

    # need to not recommend Max something he has had before
    # need to format for incoming data with user_ids, etc. 
    require 'pry'; binding.pry
  end
end
