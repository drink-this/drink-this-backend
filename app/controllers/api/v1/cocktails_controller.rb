class Api::V1::CocktailsController < ApplicationController
  before_action :authorize_user

  def show
    user = User.find_by(google_token: params[:auth_token])

    if params[:id].nil? || !params[:id].present? || params[:id].empty?
      render json: { errors: "Couldn't find Cocktail" }, status: 404
    else
      cocktail = CocktailFacade.retrieve_cocktail(user.id, params[:id])
      if cocktail[:error].present?
        render json: { errors: "Couldn't find Cocktail"}, status: 404
      else
        render json: CocktailDetailsSerializer.details(params[:id], cocktail)
      end
    end
  end

  def authorize_user
    return if current_user

    render json: { errors: "Couldn't find User" }, status: 404
  end

  def current_user
    @current_user ||= User.find_by(google_token: params[:auth_token]) if params[:auth_token]
  end
end
