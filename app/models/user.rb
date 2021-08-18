class User < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :ratings, dependent: :destroy
  has_many :cocktails, through: :ratings
end
