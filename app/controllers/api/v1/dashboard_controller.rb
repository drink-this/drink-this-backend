class Api::V1::DashboardController < Api::V1::AuthorizationController
  def index
    cocktails = Cocktail.dashboard_five(current_user.id)
    render json: CocktailDashboardSerializer.details(cocktails)
  end
end
