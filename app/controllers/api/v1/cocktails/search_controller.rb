class Api::V1::Cocktails::SearchController < Api::V1::AuthorizationController
  def index
    user = User.find_by(google_token: params[:auth_token])

    if !params[:search].present?
      render json: { errors: "Couldn't find Cocktail" }, status: :not_found
    else
      results = CocktailFacade.retrieve_search_results(params[:search], user.id)

      if results == false
        render json: { errors: "Couldn't find Cocktail" }, status: :not_found
      else
        render json: CocktailSearchSerializer.search_list(results)
      end
    end
  end
end
