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
end
