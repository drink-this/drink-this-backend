require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'relationships' do
    it {should belong_to :user}
    it {should belong_to :cocktail}
  end

  describe 'validations' do
    it {should validate_presence_of :stars}
    it {should validate_numericality_of(:stars).only_integer}
    it {should validate_numericality_of(:stars).is_greater_than_or_equal_to(0)}
    it {should validate_numericality_of(:stars).is_less_than_or_equal_to(5)}
  end

  describe 'class_methods' do
    before :all do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
    end
    
    describe '::prep_dataframe' do
      it 'returns an array of user_id, cocktail_id, and stars formatted for the dataframe build' do
        rating_1 = create(:rating, user: create(:user), cocktail: create(:cocktail), stars: 1)
        rating_2 = create(:rating, user: create(:user), cocktail: create(:cocktail), stars: 1)
        rating_3 = create(:rating, user: create(:user), cocktail: create(:cocktail), stars: 5)

        actual = [[rating_1.user_id, rating_1.cocktail_id, rating_1.stars], [rating_2.user_id, rating_2.cocktail_id, rating_2.stars], [rating_3.user_id, rating_3.cocktail_id, rating_3.stars]]
        expect(Rating.prep_dataframe).to eq(actual)
      end
    end
  end
end
