class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :cocktail

  validates :stars, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 0,
                      less_than_or_equal_to: 5
                    }

  def self.prep_dataframe
    Rating.all.select('user_id, cocktail_id, stars').map do |col|
      [col.user_id, col.cocktail_id, col.stars]
    end
  end
end
