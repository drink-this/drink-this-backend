require 'rails_helper'

RSpec.describe 'Homepage endpoint' do
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
      end

      it 'has the proper hash structure' do
        expect(response).to be_a Hash
        expect(response[:rated]).to be_a Hash
        expect(response[:rated][:cocktails]).to be_an Array

        expect(response[:unrated]).to be_a Hash
        expect(response[:unrated][:cocktails]).to be_an Array

        expect(response[:glass]).to be_a Hash
        expect(response[:glass][:type]).to be_a String
        expect(response[:glass][:cocktails]).to be_an Array

        expect(response[:alcohol]).to be_a Hash
        expect(response[:alcohol][:type]).to be_a String
        expect(response[:alcohol][:cocktails]).to be_an Array
      end
      
      it 'returns 5 rated cocktails' do
        rated = response[:rated][:cocktails]
        expect(rated.length).to eq 5

        expected = @rated_cocktails.map(&:id)
        rated.each do |drink|
          expect(expected).to include(drink[:idDrink].to_i)
        end
      end

      it 'returns 5 random unrated cocktails' do
        unrated = response[:unrated][:cocktails]
        expect(unrated.length).to eq 5
                
        expected = @unrated_cocktails.map(&:id)
        unrated.each do |drink|
          expect(expected).to include(drink[:idDrink].to_i)
        end
      end

      it 'returns 5 cocktails with a random glass type' do
        by_glass = response[:glass][:cocktails]
        expect(by_glass.length).to eq 5
  
        by_glass.each do |drink|
          expect(drink[:glass]).to eq response[:glass][:type]
        end
      end

      it 'returns 5 cocktails of a random type of alcohol' do
        alcohol_categories = ['vodka', 'rum', 'gin', 'tequila', 'scotch', 'whiskey']
        expect(alcohol_categories).to include response[:alcohol][:type]

        by_liquor = response[:alcohol][:cocktails]
        expect(by_liquor.length).to eq 5
  
        by_liquor.each do |drink|
          expect(drink.values).to include response[:alcohol][:type]
        end
      end
    end
  end 
end
