require 'rails_helper'

RSpec.describe YelpService do
  describe '::search_nearby' do
    it 'returns array of business poros', :vcr do
      manhattan = YelpFacade.search_nearby('manhattan', 'denver, co')

      expect(manhattan).to be_an Array
      expect(manhattan.first).to be_a Business
    end
  end
end
