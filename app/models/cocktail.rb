class Cocktail < ApplicationRecord
  validates :name, :thumbnail, presence: true

  has_many :ratings, dependent: :destroy
  def self.dashboard_five
    select('*')
    .from('cocktails')
    .order('Random()')
    .limit(5)
  end
end
