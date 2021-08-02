require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'relationships' do
    it {should belong_to :user}
    it {should belong_to :cocktail}
  end

  describe 'validations' do
    it {should validate_presence_of :stars}
    it {should validate_numericality_of(:stars).only_integer}
    # it {should validate_length_of(:stars).is_at_least(0).is_at_most(5)}
  end
end
