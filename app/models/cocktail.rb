class Cocktail < ApplicationRecord
  validates :name, :thumbnail, presence: true

  has_many :ratings, dependent: :destroy
  def self.dashboard_five(user_id)
    left_outer_joins(:ratings)
      .select('cocktails.*, case when ratings.stars is null then 0 else ratings.stars end as rating')
      .where('ratings.user_id is null or ratings.user_id != ?', user_id)
      .order(Arel.sql('RANDOM()'))
      .limit(5)
  end
end
