class Api::V1::YelpSearchController < ApplicationController
  def index
    results = YelpFacade.search_nearby(params[:cocktail_name], params[:location])
    render json: YelpSerializer.search_results(results)
  end
end
