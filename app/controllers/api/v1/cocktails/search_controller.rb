class Api::V1::Cocktails::SearchController < ApplicationController
  def index
    if params[:user_id].nil? || params[:user_id].empty?
      render json: { data: { error: 'Invalid user.' } }
    else
      if params[:search].nil? || params[:search].empty?
        render json: { data: { error: 'Search query not valid.'} }
      else
        results = CocktailFacade.retrieve_search_results(params[:search], params[:user_id])
        render json: CocktailSearchSerializer.search_list(results)
      end
    end
  end
end
