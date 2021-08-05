class Api::V1::DashboardController < Api::V1::AuthorizationController
  def index
    cocktails = Cocktail.dashboard_five
    render json: CocktailDashboardSerializer.details(cocktails)
  end
end
