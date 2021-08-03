class User < ApplicationRecord
  validates :name, :email, :google_token, :google_refresh_token, presence: true
  validates :email, uniqueness: true

  has_many :ratings, dependent: :destroy
end
