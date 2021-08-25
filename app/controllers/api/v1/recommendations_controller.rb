class Api::V1::RecommendationsController < Api::V1::AuthorizationController
  def show
    cocktail_id = RecommendationService.recommendation(current_user.id)
    details = CocktailFacade.retrieve_cocktail(current_user.id, cocktail_id)
    render json: CocktailDetailsSerializer.details(details)
  end
end
