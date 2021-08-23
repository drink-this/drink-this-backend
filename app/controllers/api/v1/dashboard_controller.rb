class Api::V1::DashboardController < Api::V1::AuthorizationController
  def index
    cocktails = Cocktail.sample_unrated(current_user.id, 5)
    render json: CocktailDashboardSerializer.details(cocktails)
  end
end
