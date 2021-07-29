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

  def self.user_distances(user_distance_matrix, df)
    max = user_distance_matrix.loc['Max'].sort_values(0,ascending=true)[1..5]
    df_max = Pandas.DataFrame.new(data=max, index=df.index)
  end

  def self.euclidean_distance(df)
    sklearn = PyCall.import_module("sklearn")
    euclidean = Numpy.round(sklearn.metrics.pairwise.euclidean_distances(df,df),2)
    user_distance_matrix = Pandas.DataFrame.new(data=euclidean, index=df.index,columns=df.index)
  end

  def self.create_df
    csv_data = Pandas.read_csv("./db/data/cocktail_ratings.csv") #replace with our ratings data
    df = csv_data.set_index('name').fillna(0) #will be user_id instead of name
  end

  def self.recommendation
    df = create_df

    user_distance_matrix = euclidean_distance(df)

    distances_from_user = user_distances(user_distance_matrix, df)

    cocktail_ratings = Pandas.melt(df.reset_index(),id_vars='name',value_vars=df.keys)
    scraped_ratings = cocktail_ratings[cocktail_ratings.value != 0]

    baseline_ratings = distances_from_user.reset_index().merge(scraped_ratings).dropna()

    weighted_ratings(baseline_ratings)

    combined_ratings = baseline_ratings.groupby('variable').sum()[['Max','weightedRating']]

    unrated_cocktails = remove_rated_cocktails(cocktail_ratings, combined_ratings)

    new_dataframe = Pandas.DataFrame.new()

    weighted_avg(new_dataframe, unrated_cocktails)

    best_drink = return_recommendation(new_dataframe)
  end
end
