require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it {should have_many(:ratings).dependent(:destroy)}
  end

  describe 'validations' do
    [:name, :email, :password_digest].each do |attribute|
      it {should validate_presence_of attribute}
    end

    it {should validate_uniqueness_of :email}
  end
end
