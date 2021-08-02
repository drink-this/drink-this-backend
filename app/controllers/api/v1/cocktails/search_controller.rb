class Api::V1::Cocktails::SearchController < ApplicationController
  def index
    results = CocktailFacade.retrieve_search_results(params[:search], params[:user_id])
    render json: CocktailSearchSerializer.search_list(results)
  end
end
