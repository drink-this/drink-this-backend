class Cocktail < ApplicationRecord
  validates :name, :thumbnail, presence: true

  has_many :ratings, dependent: :destroy

  def self.top_rated(user_id)
    joins(:ratings)
      .select('cocktails.*, ratings.stars as rating')
      .where('user_id = ?', user_id)
      .order('rating desc')
      .limit(5)
  end

  def self.sample_unrated(user_id, sample_size)
    left_outer_joins(:ratings)
      .select('cocktails.*, 0 as rating')
      .where('not exists (select * from ratings where cocktail_id = cocktails.id and ratings.user_id=?)', user_id)
      .distinct
      .sample(sample_size)
  end
end
