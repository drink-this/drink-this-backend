class User < ApplicationRecord
  validates :name, :email, :google_token, :google_refresh_token, presence: true
  validates_uniqueness_of :email

  has_many :ratings, dependent: :destroy
end
