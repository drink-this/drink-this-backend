class Cocktail < ApplicationRecord
  validates :name, :thumbnail, presence: true

  has_many :ratings
end
