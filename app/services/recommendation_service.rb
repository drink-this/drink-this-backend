require 'pycall/import'
include PyCall::Import

pyimport :pandas
pyimport :numpy
pyfrom :sklearn, import: :metrics
pyfrom 'sklearn.metrics', import: :pairwise
pyfrom 'sklearn.metrics.pairwise', import: :euclidean_distances

class RecommendationService

  def self.return_recommendation(recommended_cocktails)
    recommended_cocktails[recommended_cocktails.weightedAvgRecScore == recommended_cocktails.weightedAvgRecScore.max()]
  end

  def self.weighted_avg(new_dataframe, unrated_cocktails)
    # recommended_cocktails = Pandas.DataFrame.new()
    new_dataframe['weightedAvgRecScore'] = unrated_cocktails['Max']/unrated_cocktails['weightedRating']
  end

  def self.remove_rated_cocktails(pivoted_ratings, combined_ratings)
    max_pivot = pivoted_ratings[pivoted_ratings.name == 'Max'] # won't be 'Max', will be user_id (current_user.id?)
    reset_sw = combined_ratings.reset_index()
    unrated_cocktails = reset_sw.merge(max_pivot).set_index('variable')
    unrated_cocktails = unrated_cocktails[unrated_cocktails.value == 0]
  end

  def self.weighted_ratings(baseline_ratings)
    baseline_ratings['weightedRating'] = (1 / baseline_ratings['Max'] + 1) * baseline_ratings['value']
  end

  # Should take a user_id or user as a parameter (who's making the request)
  def self.recommendation
    sklearn = PyCall.import_module("sklearn")

    # Make the data into a DataFrame, set the name as an index, and make nil values into 0s
    csv_data = Pandas.read_csv("./db/data/cocktail_ratings.csv") #replace with our ratings data
    df = csv_data.set_index('name').fillna(0) #will be user_id instead of name

    # Get the euclidean distances between the vector and itself, pairwise
    euclidean = Numpy.round(sklearn.metrics.pairwise.euclidean_distances(df,df),2)
    # alternate option for measuring similarity
    # euclidean = Numpy.round(sklearn.metrics.pairwise.cosine_similarity(df,df),2)

    # making the array of euclidean distances into a new DataFrame (pairwise, so the columns and rows are both users)
    similar = Pandas.DataFrame.new(data=euclidean, index=df.index,columns=df.index)

    # get the similarities for the user requesting the recommendation (and make it into a DataFrame)
    # sort true with Euclidean Distance, false with cosine similarity
    max = similar.loc['Max'].sort_values(0,ascending=true)[1..5] #here, Max is replacing our USER_ID for the user requesting the rec
    # max = similar.loc['Max'].sort_values(0,ascending=false)[1..5] #here, Max is replacing our USER_ID for the user requesting the rec
    df_max = Pandas.DataFrame.new(data=max, index=df.index)

    # prepping the cocktail data to merge with the user similarity data
    pivoted_ratings = Pandas.melt(df.reset_index(),id_vars='name',value_vars=df.keys)

    # scraping out 0 (nil) ratings and merging similarity data with cocktail data
    scraped_pivot = pivoted_ratings[pivoted_ratings.value != 0]
    baseline_ratings = df_max.reset_index().merge(scraped_pivot).dropna()

    # creating a comparison metric (weighted rating) based on euclidean distance (ed_adjusted * rating)
    # baseline_ratings['weightedRating'] = (1 / baseline_ratings['Max'] + 1) * baseline_ratings['value']
    weighted_ratings(baseline_ratings)

    combined_ratings = baseline_ratings.groupby('variable').sum()[['Max','weightedRating']]

    unrated_cocktails = remove_rated_cocktails(pivoted_ratings, combined_ratings)

    new_dataframe = Pandas.DataFrame.new()

    weighted_avg(new_dataframe, unrated_cocktails)

    best_drink = return_recommendation(new_dataframe)
  end
end
