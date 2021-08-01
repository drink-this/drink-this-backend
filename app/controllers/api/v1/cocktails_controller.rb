class Api::V1::CocktailsController < ApplicationController
  def show
    cocktail = CocktailFacade.retrieve_cocktail(params[:cocktail_id])
    render json: CocktailDetailsSerializer.details(params[:cocktail_id], cocktail)
  end
end
