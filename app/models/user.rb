class User < ApplicationRecord
  validates :name, :email, presence: true
  validates_uniqueness_of :email

  has_many :ratings

  def self.create_from_omniauth(auth_hash)
    where(email: auth_hash.info.email).first_or_initialize do |user|
      user.uid = auth_hash.uid
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
    end
 end
end
