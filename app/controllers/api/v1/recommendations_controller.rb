class Api::V1::RecommendationsController < ApplicationController
  before_action :authorize_user

  def show
    cocktail_id = RecommendationService.recommendation(current_user.id)
    details = CocktailFacade.retrieve_cocktail(current_user.id, cocktail_id)
    # details = CocktailFacade.retrieve_cocktail(cocktail_id)
    render json: CocktailDetailsSerializer.details(cocktail_id, details)
  end

  def authorize_user
    return if current_user

    render json: { errors: "Couldn't find User" }, status: 404
  end

  def current_user
    @current_user ||= User.find_by(google_token: params[:auth_token]) if params[:auth_token]
  end
end
