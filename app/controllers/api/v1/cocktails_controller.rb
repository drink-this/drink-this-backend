class Api::V1::CocktailsController < Api::V1::AuthorizationController
  def show
    if !params[:id].present?
      render json: { error: "Couldn't find Cocktail" }, status: :not_found
    else
      cocktail = CocktailFacade.retrieve_cocktail(current_user.id, params[:id])

      if cocktail == false
        render json: { error: "Couldn't find Cocktail" }, status: :not_found
      else
        render json: CocktailDetailsSerializer.details(params[:id], cocktail)
      end
    end
  end
end
