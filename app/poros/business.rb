class Business
  attr_reader :name, :address, :business_type, :thumbnail, :yelp_link

  def initialize(result)
    @name = result[:name]
    @address = result[:location][:display_address]
    # TODO: will want to refine @business_type so it is only getting the titles, not the aliases
    @business_type = result[:categories]
    @thumbnail = result[:image_url]
    @yelp_link = result[:url]
  end
end
