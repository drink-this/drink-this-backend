class Api::V1::RecommendationsController < ApplicationController
  before_action :authorize_user

  def show
    cocktail_id = RecommendationService.recommendation(current_user.id)
    details = CocktailFacade.retrieve_cocktail(cocktail_id)
    render json: CocktailDetailsSerializer.details(cocktail_id, details)
  end

  def authorize_user
    return if current_user

    redirect_to root_path
    flash[:error] = 'Error: Please log in to view this content.'
  end

  def current_user
    @current_user ||= User.find(google_token: params[:auth_token]) if params[:auth_token]
  end
end
