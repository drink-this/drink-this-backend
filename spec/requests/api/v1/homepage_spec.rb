require 'rails_helper'

RSpec.describe 'Homepage endpoint' do
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end
  
  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  describe 'GET /homepage' do
    before :each do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
    end

    context 'successfully returns all data needed for the homepage' do
      before :each do
        @user1 = create(:user)
        @user2 = create(:user)
    
        @rated_cocktails = create_list(:cocktail, 8)
        @rated_cocktails.each do |cocktail|
          Rating.create!(user: @user1, cocktail: cocktail, stars: 4)
        end
    
        @unrated_cocktails = create_list(:cocktail, 8)

        get '/api/v1/homepage', params: { auth_token: @user1.google_token }

        @result = JSON.parse(response.body, symbolize_names: true)
      end

      it 'has the proper hash structure' do
        expect(response.status).to eq(200)

        expect(@result).to be_a Hash
        expect(@result[:data][:id]).to eq nil
        expect(@result[:data][:type]).to eq 'homepage'

        details = @result[:data][:attributes]
        expect(details).to be_a Hash

        rated = details[:rated]
        expect(rated).to be_a Hash
        expect(rated[:cocktails]).to be_an Array

        unrated = details[:unrated]
        expect(unrated).to be_a Hash
        expect(unrated[:cocktails]).to be_an Array

        glass = details[:glass]
        expect(glass).to be_a Hash
        expect(glass[:type]).to be_a String
        expect(glass[:cocktails]).to be_an Array

        alcohol = details[:alcohol]
        expect(alcohol).to be_a Hash
        expect(alcohol[:type]).to be_a String
        expect(alcohol[:cocktails]).to be_an Array
      end
      
      it 'returns 5 rated cocktails' do
        details = @result[:data][:attributes]
        rated = details[:rated][:cocktails]

        expect(rated.length).to eq 5

        expected = @rated_cocktails.map(&:id)
        rated.each do |drink|
          expect(expected).to include(drink[:id].to_i)
        end
      end

      it 'returns 5 random unrated cocktails' do
        details = @result[:data][:attributes]
        unrated = details[:unrated][:cocktails]

        expect(unrated.length).to eq 5
                
        expected = @unrated_cocktails.map(&:id)
        unrated.each do |drink|
          expect(expected).to include(drink[:id].to_i)
        end
      end

      it 'returns 5 cocktails with a random glass type' do
        details = @result[:data][:attributes]
        by_glass = details[:glass][:cocktails]

        glass_types = ['Collins Glass', 'Highball glass', 'Old-fashioned glass', 'Champagne flute', 'Pint glass', 'Martini Glass']
        expect(glass_types).to include details[:glass][:type]

        expect(by_glass.length).to eq 5
      end

      it 'returns 5 cocktails of a random type of alcohol' do
        details = @result[:data][:attributes]
        by_liquor = details[:alcohol][:cocktails]

        alcohol_types = ['Gin', 'Bourbon', 'Scotch', 'Rum', 'Tequila', 'Vodka']
        expect(alcohol_types).to include details[:alcohol][:type]

        expect(by_liquor.length).to eq 5
      end
    end
  end
end
