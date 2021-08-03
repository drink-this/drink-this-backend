require 'rails_helper'

RSpec.describe 'Yelp Cocktail Search API' do
  describe 'show response endpoint' do
    it 'sends json of list of businesses', :vcr do
      get '/api/v1/yelp_search', params: {
        location: "denver, co",
        cocktail_name: "manhattan"
      }

      expect(response.status).to eq(200)

      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results[:data]).to be_an Array
      expect(search_results[:data][0]).to have_key(:type)

      first_result = search_results[:data].first

      expect(first_result[:type]).to eq('yelp_cocktail_search')
      expect(first_result[:attributes][:name]).to be_a String
      expect(first_result[:attributes][:address]).to be_a String
      expect(first_result[:attributes][:business_type]).to be_an Array
      expect(first_result[:attributes][:thumbnail]).to be_a String
      expect(first_result[:attributes][:yelp_link]).to be_a String
    end
  end
end


# When a client sends a get request to "/api/v1/search/yelp", with a valid param in request body called "query" of type string, the response would be the results:
#
# {
# "data": [ {
#    "type"; "yelp cocktail search"
#    "attributes": {
  #    "name": "business name",
  #    "address": "business address",
  #    "business_type": "type of business",
  #    "thumbnail": "business thumbnail",
  #    "yelp_link": "yelp link to business"
  # }
# } ]
# }


# request headers
  # Authorization: "Bearer #{YELP_KEY}"
# params
  # term: "manhattan"
  # location: "san francisco"
  # limit: 10
  # categories: 'bars'
