class Api::V1::Cocktails::SearchController < Api::V1::AuthorizationController
  def index
    if !params[:search].present?
      render json: { error: "Couldn't find Cocktail" }, status: :not_found
    else
      results = CocktailFacade.retrieve_search_results(params[:search], current_user.id)

      if results == false
        render json: { error: "Couldn't find Cocktail" }, status: :not_found
      else
        render json: CocktailSearchSerializer.search_list(results)
      end
    end
  end
end
