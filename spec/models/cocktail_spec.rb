require 'rails_helper'

RSpec.describe Cocktail, type: :model do
  describe 'relationships' do
    it {should have_many(:ratings).dependent(:destroy)}
  end

  describe 'validations' do
    [:name, :thumbnail].each do |attribute|
      it {should validate_presence_of attribute}
    end
  end

  describe 'class_methods' do
    before :all do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
    end

    describe 'random_five' do
      it 'returns 5 random cocktails and ratings if available' do
        user = create(:user)

        cocktail_1 = create(:cocktail, id: 11324)
        cocktail_2 = create(:cocktail, id: 11005)
        cocktail_3 = create(:cocktail, id: 11408)
        cocktail_4 = create(:cocktail, id: 11415)
        cocktail_5 = create(:cocktail, id: 11419)
        cocktail_6 = create(:cocktail, id: 13202)
        cocktail_7 = create(:cocktail, id: 17197)
        cocktail_8 = create(:cocktail, id: 11382)
        cocktail_9 = create(:cocktail, id: 15427)
        cocktail_10 = create(:cocktail, id: 17230)
        cocktail_11 = create(:cocktail, id: 11410)
        cocktail_12 = create(:cocktail, id: 13070)

        ids = [11324, 11005, 11408, 11415, 11419, 13202, 17197, 11382, 15427, 17230, 11410, 13070]

        expect(Cocktail.dashboard_five(user.id).length).to eq(5)
        expect(Cocktail.dashboard_five(user.id).first).to be_a Cocktail
        expect(ids).to include(Cocktail.dashboard_five(user.id).first.id) 
        #expect(Cocktail.dashboard_five(user.id).first.rating).to eq 0
      end

      it 'checks for ratings for the given user' do
        user = create(:user)
        user_2 = create(:user)

        cocktail_1 = create(:cocktail, id: 11324)
        cocktail_2 = create(:cocktail, id: 11005)
        cocktail_3 = create(:cocktail, id: 11408)
        cocktail_4 = create(:cocktail, id: 11415)
        cocktail_5 = create(:cocktail, id: 11419)

        create(:rating, cocktail: cocktail_1, user: user, stars: 3)
        create(:rating, cocktail: cocktail_2, user: user, stars: 3)
        create(:rating, cocktail: cocktail_3, user: user, stars: 3)
        create(:rating, cocktail: cocktail_4, user: user, stars: 3)
        create(:rating, cocktail: cocktail_5, user: user, stars: 3)

        create(:rating, cocktail: cocktail_1, user: user_2, stars: 5)
        create(:rating, cocktail: cocktail_2, user: user_2, stars: 5)
        create(:rating, cocktail: cocktail_3, user: user_2, stars: 5)
        create(:rating, cocktail: cocktail_4, user: user_2, stars: 5)
        create(:rating, cocktail: cocktail_5, user: user_2, stars: 5)

        ids = [11324, 11005, 11408, 11415, 11419]
        expect(Cocktail.dashboard_five(user.id).length).to eq(5)
        expect(Cocktail.dashboard_five(user.id).first).to be_a Cocktail
        expect(ids).to include(Cocktail.dashboard_five(user.id).first.id) 
        #expect(Cocktail.dashboard_five(user.id).first.rating).to eq 3
      end
    end

    describe '::sample_rated' do
      before :each do
        @user1 = create(:user)
        @user2 = create(:user)
    
        @rated_cocktails = create_list(:cocktail, 6)
        @rated_cocktails.each do |cocktail|
          Rating.create!(user: @user1, cocktail: cocktail, stars: 4)
        end

        @rated_for_alt_user = create_list(:cocktail, 2)
        @rated_for_alt_user.each do |cocktail|
          Rating.create!(user: @user2, cocktail: cocktail, stars: 2)
        end
    
        @unrated_cocktails = create_list(:cocktail, 6)
      end

      it 'returns specified length sample from rated cocktails' do
        rated_sample = @user1.cocktails.sample_rated(5)

        expect(rated_sample.length).to eq 5
        expect(rated_sample.first).to be_a Cocktail
        rated_sample.each do |cocktail|
          expect(@rated_cocktails).to include(cocktail)
          expect(@rated_for_alt_user).not_to include(cocktail)
          expect(@unrated_cocktails).not_to include(cocktail)
        end
      end

      it 'returns only as many are rated, if less than sample requested' do
        rated_sample = @user1.cocktails.sample_rated(8)

        expect(rated_sample.length).to eq 6
      end

      it 'returns an empty array if no cocktails have been rated' do
        user3 = create(:user)

        rated_sample = user3.cocktails.sample_rated(5)
        expect(rated_sample).to eq([])
      end
    end

    describe '::sample_unrated' do
      before :each do
        @user1 = create(:user)
    
        @rated_cocktails = create_list(:cocktail, 6)
        @rated_cocktails.each do |cocktail|
          Rating.create!(user: @user1, cocktail: cocktail, stars: 4)
        end
    
        @unrated_cocktails = create_list(:cocktail, 6)
      end

      it 'returns specified length sample from unrated cocktails' do
        unrated_sample = @user1.cocktails.sample_unrated(5)

        expect(unrated_sample.length).to eq 5
        expect(unrated_sample.first).to be_a Cocktail
        unrated_sample.each do |cocktail|
          expect(@unrated_cocktails).to include(cocktail)
          expect(@rated_cocktails).not_to include(cocktail)
        end
      end

      it 'returns only as many are unrated, if less than sample requested' do
        unrated_sample = @user1.cocktails.sample_unrated(8)

        expect(unrated_sample.length).to eq 6
      end

      it 'returns an empty array if no cocktails are left unrated' do
        @unrated_cocktails.each do |cocktail|
          Rating.create!(user: @user1, cocktail: cocktail, stars: 2)
        end

        unrated_sample = @user1.cocktails.sample_unrated(5)
        expect(rated_sample).to eq([])
      end
    end
  end
end
  