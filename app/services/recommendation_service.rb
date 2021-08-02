require 'pycall/import'
include PyCall::Import

pyimport :pandas
pyimport :numpy
pyfrom :sklearn, import: :metrics
pyfrom 'sklearn.metrics', import: :pairwise
pyfrom 'sklearn.metrics.pairwise', import: :euclidean_distances

class RecommendationService
  include Dataframeable

  def self.return_recommendation(recommended_cocktails)
    recommended_cocktails[recommended_cocktails.weightedAvgRecScore == recommended_cocktails.weightedAvgRecScore.max()]
  end

  def self.weighted_avg(new_dataframe, unrated_cocktails, user_id)
    new_dataframe['weightedAvgRecScore'] = unrated_cocktails[user_id]/unrated_cocktails['weightedRating']
  end

  def self.remove_rated_cocktails(pivoted_ratings, combined_ratings, user_id)
    user_pivot = pivoted_ratings[pivoted_ratings.user_id == user_id]
    reset_sw = combined_ratings.reset_index()
    unrated_cocktails = reset_sw.merge(user_pivot).set_index('cocktail_id')
    unrated_cocktails = unrated_cocktails[unrated_cocktails.value == 0]
  end

  def self.weighted_ratings(baseline_ratings, user_id)
    baseline_ratings['weightedRating'] = (1 / baseline_ratings[user_id] + 1) * baseline_ratings['value']
  end

  def self.user_distances(user_distance_matrix, df, user_id)
    other_users = user_distance_matrix.loc[user_id].sort_values(0,ascending=true)
    user_removed = other_users[other_users>0][0..4]
    Pandas.DataFrame.new(data=user_removed, index=df.index)
  end

  def self.euclidean_distance(df)
    sklearn = PyCall.import_module("sklearn")
    euclidean = Numpy.round(sklearn.metrics.pairwise.euclidean_distances(df,df),2)
    user_distance_matrix = Pandas.DataFrame.new(data=euclidean, index=df.index,columns=df.index)
  end

  def self.recommendation(user_id)
    df = Dataframeable.create_df

    user_distance_matrix = euclidean_distance(df)

    distances_from_user = user_distances(user_distance_matrix, df, user_id)

    cocktail_ratings = Pandas.melt(df.reset_index(),id_vars='user_id',value_vars=df.keys)
    scraped_ratings = cocktail_ratings[cocktail_ratings.value != 0]

    baseline_ratings = distances_from_user.reset_index().merge(scraped_ratings).dropna()

    weighted_ratings(baseline_ratings, user_id)

    combined_ratings = baseline_ratings.groupby('cocktail_id').sum()[[user_id,'weightedRating']]

    unrated_cocktails = remove_rated_cocktails(cocktail_ratings, combined_ratings, user_id)

    new_dataframe = Pandas.DataFrame.new()

    weighted_avg(new_dataframe, unrated_cocktails, user_id)

    return_recommendation(new_dataframe)
  end
end
