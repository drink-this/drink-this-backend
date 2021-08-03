class YelpSerializer < ActiveModel::Serializer
  attributes :name, :address, :business_type, :thumbnail, :yelp_link

  def self.search_results(results)
    {
      data:
        results.map do |result|
          {
            type: 'yelp_search_result',
            attributes: {
              name: result.name,
              address: result.address,
              business_type: result.business_type,
              thumbnail: result.thumbnail,
              yelp_link: result.yelp_link
            }
          }
        end
    }.to_json
  end
end
