require 'rails_helper'

RSpec.describe Homepage do
  it 'contains all necessary data for homepage display', :vcr do
    VCR.use_cassette('homepage_poro', :match_requests_on => [:method, VCR.request_matchers.uri_without_params(:g, :s, :i)]) do

      user = create(:user)

      rated_cocktails = create_list(:cocktail, 5)
      rated_cocktails.each do |cocktail|
        Rating.create!(user: user, cocktail: cocktail, stars: 4)
      end

      unrated_cocktails = create_list(:cocktail, 5)

      homepage = Homepage.new(user)

      expect(homepage).to be_a Homepage

      expect(homepage.rated[:cocktails]).to be_an Array
      expect(homepage.rated[:cocktails].length).to eq 5
      homepage.rated[:cocktails].each do |cocktail|
        expect(cocktail).to be_a Hash
        expect(cocktail[:rating] > 0).to be true
      end

      expect(homepage.unrated[:cocktails]).to be_an Array
      expect(homepage.unrated[:cocktails].length).to eq 5
      homepage.unrated[:cocktails].each do |cocktail|
        expect(cocktail).to be_a Hash
        expect(cocktail[:rating]).to eq 0
      end

      expect(homepage.glass).to be_a Hash
      expect(homepage.glass[:type]).to be_a String
      expect(homepage.glass[:cocktails]).to be_an Array
      expect(homepage.glass[:cocktails].length).to eq 5
      homepage.glass[:cocktails].each do |cocktail|
        expect(cocktail).to be_a Hash
      end

      expect(homepage.alcohol).to be_a Hash
      expect(homepage.alcohol[:type]).to be_a String
      expect(homepage.alcohol[:cocktails]).to be_an Array
      expect(homepage.alcohol[:cocktails].length).to eq 5
      homepage.glass[:cocktails].each do |cocktail|
        expect(cocktail).to be_a Hash
      end
    end
  end
end
