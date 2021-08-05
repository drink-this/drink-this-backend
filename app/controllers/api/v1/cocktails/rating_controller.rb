class Api::V1::Cocktails::RatingController < Api::V1::AuthorizationController
  def create
    create_cocktail(params[:id]) if Cocktail.where(id: params[:id]).empty?
    rating = Rating.find_or_create_by(user_id: current_user.id, cocktail_id: params[:id])
    rating.stars = params[:stars]
    if rating.save
      render json: rating, status: :created
    else
      render json: { error: 'Failed to create resource', messages: rating.errors.full_messages },
             status: :bad_request
    end
  end

  def create_cocktail(cocktail_id)
    details = CocktailFacade.retrieve_cocktail(current_user.id, cocktail_id)
    Cocktail.create(id: cocktail_id, name: details[:name], thumbnail: details[:thumbnail]) unless details == false
  end
end
