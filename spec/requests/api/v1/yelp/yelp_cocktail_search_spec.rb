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

      expect(first_result[:type]).to eq('yelp_search_result')
      expect(first_result[:attributes][:name]).to be_a String
      expect(first_result[:attributes][:address]).to be_a Array
      expect(first_result[:attributes][:business_type]).to be_an Array
      expect(first_result[:attributes][:thumbnail]).to be_a String
      expect(first_result[:attributes][:yelp_link]).to be_a String
    end
  end
end
