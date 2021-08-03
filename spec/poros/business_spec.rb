require 'rails_helper'

RSpec.describe Business do
  describe '#initialize' do
    it 'abstracts and encapsulates cocktail data that be read' do
      details = {
        :name=>"Union Lodge No.1",
        :thumbnail=>"https://s3-media2.fl.yelpcdn.com/bphoto/oQcctWaIVGkoE1pKGlHA6Q/o.jpg",
        :address=>["1543 Champa St", "Denver, CO 80202"],
        :business_type=>[{"alias": "cocktailbars", "title": "Cocktail Bars"}, { "alias": "lounges", "title": "Lounges"}],
        :yelp_link=>"https://www.yelp.com/biz/union-lodge-no-1-denver?adjust_creative=9gPw-kuPiDZgFQ3Tr4ox3Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=9gPw-kuPiDZgFQ3Tr4ox3Q"
      }

      union_lodge = Business.new(details)

      expect(union_lodge.name).to eq('Union Lodge No.1')
      expect(union_lodge.thumbnail).to eq('https://s3-media2.fl.yelpcdn.com/bphoto/oQcctWaIVGkoE1pKGlHA6Q/o.jp')
      expect(union_lodge.address).to eq(['1543 Champa St', 'Denver, CO 80202'])
      expect(union_lodge.business_type).to eq([{'alias': 'cocktailbars', 'title': 'Cocktail Bars'}, { 'alias': 'lounges', 'title': 'Lounges'}])
      expect(union_lodge.yelp_link).to eq('https://www.yelp.com/biz/union-lodge-no-1-denver?adjust_creative=9gPw-kuPiDZgFQ3Tr4ox3Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=9gPw-kuPiDZgFQ3Tr4ox3Q')
    end
  end
end
