class HomepageSerializer
  include JSONAPI::Serializer
  attributes :rated, :unrated, :glass, :alcohol
end
