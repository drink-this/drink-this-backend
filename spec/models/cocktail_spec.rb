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
      it 'returns 5 random cocktails' do
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

        expect(Cocktail.dashboard_five.length).to eq(5)
        expect(Cocktail.dashboard_five.first).to be_a(Cocktail)
      end
    end
  end
end
