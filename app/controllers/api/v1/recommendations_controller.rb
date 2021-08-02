class Api::V1::RecommendationsController < Api::V1::AuthenticationController
  def show
    require 'pry'; binding.pry
    cocktail_id = RecommendationService.recommendation(current_user.id)
    details = CocktailFacade.retrieve_cocktail(cocktail_id)
    render json: CocktailDetailsSerializer.details(cocktail_id, details)
  end
end
