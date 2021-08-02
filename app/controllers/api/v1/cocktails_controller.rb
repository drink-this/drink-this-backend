class Api::V1::CocktailsController < ApplicationController
  def show
    cocktail = CocktailFacade.retrieve_cocktail(params[:id])
    render json: CocktailDetailsSerializer.details(params[:id], cocktail)
  end
end
