class Api::V1::CocktailsController < Api::V1::AuthorizationController
  def show
    cocktail = CocktailFacade.retrieve_cocktail(current_user.id, params[:id])
    render json: CocktailDetailsSerializer.details(params[:id], cocktail)
  end
end
