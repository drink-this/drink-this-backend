class User < ApplicationRecord
  validates :name, :email, :password_digest, presence: true
  validates_uniqueness_of :email

  has_many :ratings
end
