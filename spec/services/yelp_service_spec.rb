require 'rails_helper'

RSpec.describe YelpService do
  describe '::get_businesses' do
    it 'returns search results', :vcr do
      response = YelpService.get_businesses('manhattan', 'denver, co')

      expect(response).to be_a Hash
      expect(response[:businesses]).to be_an Array

      union_lodge = response[:businesses].first

      expect(union_lodge).to be_a Hash
      expect(union_lodge[:name]).to eq('Union Lodge No.1')
      expect(union_lodge[:image_url]).to eq('https://s3-media2.fl.yelpcdn.com/bphoto/oQcctWaIVGkoE1pKGlHA6Q/o.jpg')
      expect(union_lodge[:url]).to eq('https://www.yelp.com/biz/union-lodge-no-1-denver?adjust_creative=9gPw-kuPiDZgFQ3Tr4ox3Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=9gPw-kuPiDZgFQ3Tr4ox3Q')
      expect(union_lodge[:categories]).to eq([{:alias=>"cocktailbars", :title=>"Cocktail Bars"}, {:alias=>"lounges", :title=>"Lounges"}])
      expect(union_lodge[:location][:display_address]).to eq(["1543 Champa St", "Denver, CO 80202"])


      guard_and_grace = response[:businesses].second

      expect(guard_and_grace).to be_a Hash
      expect(guard_and_grace).to have_key(:name)
      expect(guard_and_grace).to have_key(:image_url)
      expect(guard_and_grace).to have_key(:url)
      expect(guard_and_grace).to have_key(:categories)
      expect(guard_and_grace[:categories].first).to have_key(:alias)
      expect(guard_and_grace[:categories].first).to have_key(:title)
      expect(guard_and_grace).to have_key(:location)
      expect(guard_and_grace[:location]).to have_key(:display_address)
    end
  end
end
