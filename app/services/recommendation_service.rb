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

  def self.weighted_avg(new_dataframe, unrated, user_id)
    new_dataframe['weightedAvgRecScore'] = unrated['sum_weightedRating']/unrated['count_ratings']
  end

  def self.remove_rated(pivoted_ratings, all_of_it, user_id)
    user_pivot = pivoted_ratings[pivoted_ratings.user_id == user_id]
    reset_sw = all_of_it.reset_index()
    unrated = reset_sw.merge(user_pivot).set_index('cocktail_id')
    unrated = unrated[unrated.value == 0]
  end







  def self.weighted_baselines_with_counts(baselines, weighted_baselines)
    counts = baselines.groupby('cocktail_id').agg('count')['value']
    complete = weighted_baselines.join(counts)
    complete.columns = ['similarity', 'sum_weightedRating','count_ratings']
    complete
  end

  def self.recommendation(user_id)
    df = Dataframeable.create_df

    cocktail_ratings = Pandas.melt(df.reset_index(),id_vars='user_id',value_vars=df.keys)

    baselines = merge_distances_and_ratings(cocktail_ratings, df, user_id)

    weighted_ratings(baselines, user_id)

    weighted_baselines = baselines.groupby('cocktail_id').sum()[[user_id,'weightedRating']]

    ratings_complete = weighted_baselines_with_counts(baselines, weighted_baselines)

    unrated = remove_rated(cocktail_ratings, ratings_complete, user_id)

    new_dataframe = Pandas.DataFrame.new()
    weighted_avg(new_dataframe, unrated, user_id)
    return_recommendation(new_dataframe).reset_index['cocktail_id'].to_i
  end

  def self.distances_from_user(df, user_id)
    user_distance_matrix = euclidean_distance(df)
    user_distances(user_distance_matrix, df, user_id)
  end

  def self.euclidean_distance(df)
    sklearn = PyCall.import_module("sklearn")
    euclidean = Numpy.round(sklearn.metrics.pairwise.euclidean_distances(df,df),2)
    user_distance_matrix = Pandas.DataFrame.new(data=euclidean, index=df.index,columns=df.index)
  end

  def self.user_distances(user_distance_matrix, df, user_id)
    other_users = user_distance_matrix.loc[user_id].sort_values(0,ascending=true)
    cap = (other_users.size * 0.15).ceil
    user_removed = other_users[other_users>0][0..cap]
    Pandas.DataFrame.new(data=user_removed, index=df.index)
  end

  def self.merge_distances_and_ratings(cocktail_ratings, df, user_id)
    only_rated = cocktail_ratings[cocktail_ratings.value != 0]
    distances_from_user(df, user_id).reset_index().merge(only_rated).dropna()
  end

  def self.weighted_ratings(baseline_ratings, user_id)
    baseline_ratings[user_id] = (1 / (baseline_ratings[user_id] + 1))
    baseline_ratings['weightedRating'] = baseline_ratings[user_id] * baseline_ratings['value']
  end
end
