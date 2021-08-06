class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :cocktail

  validates :stars, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 0,
                      less_than_or_equal_to: 5
                    }
  # validates :user_id, uniqueness: {scope: :cocktail_id}

  def self.prep_dataframe
    Rating.pluck(:user_id, :cocktail_id, :stars)
  end
end
