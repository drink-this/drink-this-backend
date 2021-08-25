require 'rails_helper'

RSpec.describe CocktailFacade, :vcr do
  VCR.use_cassette('cocktail drink', :record => :new_episodes) do
    describe '::retrieve_cocktail' do
      before :each do
        User.destroy_all
        Cocktail.destroy_all
        Rating.destroy_all
      end

      it 'returns json with cocktail details and rating' do
        user = create(:user)

        vodka_fizz = CocktailFacade.retrieve_cocktail(user.id, '16967')

        expect(vodka_fizz).to have_key :name
        expect(vodka_fizz[:id]).to eq('16967')

        expect(vodka_fizz).to have_key :name
        expect(vodka_fizz[:name]).to eq('Vodka Fizz')

        expect(vodka_fizz).to have_key :thumbnail
        expect(vodka_fizz[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/xwxyux1441254243.jpg')

        expect(vodka_fizz).to have_key :glass
        expect(vodka_fizz[:glass]).to eq('White wine glass')

        expect(vodka_fizz).to have_key :recipe
        expect(vodka_fizz[:recipe]).to be_an Array
        expect(vodka_fizz[:recipe].length).to eq(5)
        expect(vodka_fizz[:recipe].first).to eq('2 oz Vodka')
        expect(vodka_fizz[:recipe].last).to eq('Nutmeg')

        expect(vodka_fizz).to have_key :instructions
        expect(vodka_fizz[:instructions]).to eq('Blend all ingredients, save nutmeg. Pour into large white wine glass and sprinkle nutmeg on top.')

        expect(vodka_fizz).to have_key :rating
        expect(vodka_fizz[:rating]).to eq(0)
      end

      it 'returns rating if present' do
        user = create(:user)
        create(:cocktail, id: 16967)
        create(:rating, cocktail_id: 16967, user_id: user.id, stars: 4)
        vodka_fizz = CocktailFacade.retrieve_cocktail(user.id, '16967')

        expect(vodka_fizz[:rating]).to eq(4)
      end
    end
  end

  describe '::retrieve_details' do
    before :each do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
    end

    it 'returns json with cocktail details and rating' do
      user = create(:user)

      cocktail = CocktailFacade.retrieve_cocktail(user.id, nil)

      expect(cocktail).to have_key :id
      expect(cocktail).to have_key :name
      expect(cocktail).to have_key :thumbnail
      expect(cocktail).to have_key :glass
      expect(cocktail).to have_key :recipe
      expect(cocktail[:recipe]).to be_an Array

      expect(cocktail).to have_key :instructions
      expect(cocktail).to have_key :rating
      expect(cocktail[:rating]).to eq(0)
    end
  end

  describe '::retrieve_by_glass' do
    before :each do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
    end

    it 'returns cocktails for glass type and ratings' do
      user = create(:user)

      cocktails = CocktailFacade.retrieve_by_glass('Collins glass', user.id)

      expect(cocktails).to be_an Array

      expect(cocktails.first).to be_a Hash
      expect(cocktails.first).to have_key :id
      expect(cocktails.first).to have_key :name
      expect(cocktails.first).to have_key :thumbnail
      expect(cocktails.first).to have_key :rating
      expect(cocktails.first[:rating]).to eq(0)
    end

    it 'returns an empty array if no cocktails for glass type' do
      user = create(:user)

      cocktails = CocktailFacade.retrieve_by_glass('rocks', user.id)

      expect(cocktails).to eq false
    end
  end


  describe '::retrieve_search_results' do
    before :each do
      User.destroy_all
      Cocktail.destroy_all
      Rating.destroy_all
    end

    it 'returns json with list of cocktails by query', :vcr do
      user = create(:user)
      create(:cocktail, id: 11324)
      create(:cocktail, id: 11005)
      create(:rating, cocktail_id: 11324, user_id: user.id, stars: 4)
      create(:rating, cocktail_id: 11005)

      dry = CocktailFacade.retrieve_search_results('dry', user.id)

      expect(dry).to be_an Array

      result_1 = dry.first

      expect(result_1).to be_a Hash
      expect(result_1[:id]).to eq('11324')
      expect(result_1[:name]).to eq('Dry Rob Roy')
      expect(result_1[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/typuyq1439456976.jpg')
      expect(result_1[:rating]).to eq(4)

      result_2 = dry.second

      expect(result_2).to be_a Hash
      expect(result_2[:id]).to eq('11005')
      expect(result_2[:name]).to eq('Dry Martini')
      expect(result_2[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/6ck9yi1589574317.jpg')
      expect(result_2[:rating]).to eq(0)
    end

    it 'returns search results by name and ingredient', :vcr do
      user = create(:user)
      create(:cocktail, id: 12618)
      create(:cocktail, id: 17834)
      create(:rating, cocktail_id: 12618, user_id: user.id, stars: 1)
      create(:rating, cocktail_id: 17834, user_id: user.id, stars: 3)

      orange_drinks = CocktailFacade.retrieve_search_results('orange', user.id)

      expect(orange_drinks).to be_an Array
      expect(orange_drinks.length).to eq 11

      result_1 = orange_drinks.first

      expect(result_1).to be_a Hash
      expect(result_1[:id]).to eq('12618')
      expect(result_1[:name]).to eq('Orangeade')
      expect(result_1[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/ytsxxw1441167732.jpg')
      expect(result_1[:rating]).to eq(1)

      result_2 = orange_drinks[9]

      expect(result_2).to be_a Hash
      expect(result_2[:id]).to eq('17834')
      expect(result_2[:name]).to eq('Abbey Cocktail')
      expect(result_2[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/mr30ob1582479875.jpg')
      expect(result_2[:rating]).to eq(3)
    end

    it 'returns search results by name (ingredient does not exist)', :vcr do
      user = create(:user)
      create(:cocktail, id: 13497)
      create(:cocktail, id: 17002)
      create(:rating, cocktail_id: 13497, user_id: user.id, stars: 1)
      create(:rating, cocktail_id: 17002, user_id: user.id, stars: 2)
      
      results = CocktailFacade.retrieve_search_results('Green', user.id)

      expect(results).to be_an Array
      expect(results.length).to eq 3

      result_1 = results.first

      expect(result_1).to be_a Hash
      expect(result_1[:id]).to eq('13497')
      expect(result_1[:name]).to eq('Green Goblin')
      expect(result_1[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/qxprxr1454511520.jpg')
      expect(result_1[:rating]).to eq(1)

      result_2 = results.last

      expect(result_2).to be_a Hash
      expect(result_2[:id]).to eq('17002')
      expect(result_2[:name]).to eq("Gideon's Green Dinosaur")
      expect(result_2[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/p5r0tr1503564636.jpg')
      expect(result_2[:rating]).to eq(2)
    end

    it 'returns search results by name (name does not exist)', :vcr do
      user = create(:user)
      create(:cocktail, id: 17254)
      create(:cocktail, id: 17828)
      create(:rating, cocktail_id: 17254, user_id: user.id, stars: 5)
      create(:rating, cocktail_id: 17828, user_id: user.id, stars: 4)
      
      results = CocktailFacade.retrieve_search_results('Green Chartreuse', user.id)

      expect(results).to be_an Array
      expect(results.length).to eq 5

      result_1 = results.first

      expect(result_1).to be_a Hash
      expect(result_1[:id]).to eq('17254')
      expect(result_1[:name]).to eq('Bijou')
      expect(result_1[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/rysb3r1513706985.jpg')
      expect(result_1[:rating]).to eq(5)

      result_2 = results.last

      expect(result_2).to be_a Hash
      expect(result_2[:id]).to eq('17828')
      expect(result_2[:name]).to eq('Tipperary')
      expect(result_2[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/b522ek1521761610.jpg')
      expect(result_2[:rating]).to eq(4)
    end

    it 'does not return duplicate cocktails', :vcr do
      user = create(:user)
      create(:cocktail, id: 178325)

      cocktails = CocktailFacade.retrieve_search_results('aperol', user.id)

      expect(cocktails).to be_an Array
      expect(cocktails.length).to eq 3

      result_1 = cocktails.first

      expect(result_1).to be_a Hash
      expect(result_1[:id]).to eq('178325')
      expect(result_1[:name]).to eq('Aperol Spritz')
      expect(result_1[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/iloasq1587661955.jpg')
      expect(result_1[:rating]).to eq(0)

      result_2 = cocktails.second

      expect(result_2).to be_a Hash
      expect(result_2[:id]).to eq('12706')
      expect(result_2[:name]).to eq('Imperial Cocktail')
      expect(result_2[:thumbnail]).to eq('https://www.thecocktaildb.com/images/media/drink/bcsj2e1487603625.jpg')
      expect(result_2[:rating]).to eq(0)
    end
  end
end
