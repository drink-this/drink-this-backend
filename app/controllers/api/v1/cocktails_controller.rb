class Api::V1::CocktailsController < ApplicationController
  before_action :authorize_user
  
  def show
    if params[:id].nil?
      render json: { error: 'No cocktail currently exist.' }
    else
      if params[:user_id].nil? || Rating.find_by(cocktail_id: params[:id], user_id: params[:user_id]).nil?
        render json: { error: 'User error.'}
      else
        cocktail = CocktailFacade.retrieve_cocktail(params[:id])
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
