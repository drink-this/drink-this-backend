class Api::V1::CocktailsController < Api::V1::AuthorizationController
  def show
    if params[:id].blank?
      render json: { error: "Couldn't find Cocktail" }, status: :not_found
    else
      cocktail = CocktailFacade.retrieve_cocktail(current_user.id, params[:id])

      if cocktail == false
        render json: { error: "Couldn't find Cocktail" }, status: :not_found
      else
        render json: CocktailDetailsSerializer.details(cocktail)
      end
    end
  end

  def rated
    cocktails = current_user.cocktails.select('cocktails.*, ratings.stars')
    render json: RatedCocktailsSerializer.serialize(cocktails).to_json
  end
end
