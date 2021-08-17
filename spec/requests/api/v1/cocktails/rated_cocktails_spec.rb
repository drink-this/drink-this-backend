require 'rails_helper'

RSpec.describe 'Rated Cocktails' do
  before :all do
    @user1 = create(:user)
    @user2 = create(:user)

    @cocktails1 = create_list(:cocktail, 3)
    @cocktails1.each do |cocktail|
      Rating.create!(user: @user1, cocktail: cocktail, stars: 1)
    end

    @cocktails2 = create_list(:cocktail, 3)
    @cocktails2.each do |cocktail|
      Rating.create!(user: @user2, cocktail: cocktail, stars: 1)
    end
  end

  it 'returns a list of rated cocktails for the user' do
    get '/api/v1/cocktails/rated', params: { auth_token: @user1.google_token }
    data = JSON.parse(response.body)['data']
    expect(data.keys).to include('id', 'type', 'attributes')
    attrs = data['attributes'].map { |attr| attr['id']}
    ids = @cocktails1.map(&:id)
    not_ids = @cocktails2.map(&:id)
    expect(attrs).to match_array(ids)
    expect(attrs).to_not match_array(not_ids)
  end
end