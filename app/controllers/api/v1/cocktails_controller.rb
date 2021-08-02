class Api::V1::CocktailsController < ApplicationController
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
end
