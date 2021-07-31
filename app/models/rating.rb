class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :cocktail

  validates :stars, presence: true, numericality: { only_integer: true }
end
