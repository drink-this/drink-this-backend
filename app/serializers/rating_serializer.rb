class RatingSerializer < ActiveModel::Serializer
  type :cocktail_rating
  attributes :user_id, :cocktail_id, :stars
end
