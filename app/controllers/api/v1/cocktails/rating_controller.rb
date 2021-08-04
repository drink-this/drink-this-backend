class Api::V1::Cocktails::RatingController < Api::V1::AuthorizationController
  def create
    # require 'pry'; binding.pry
    rating = Rating.new(user_id: current_user.id, cocktail_id: params[:id], stars: params[:stars])
    if rating.save
      render json: rating, status: :created
    else
      # cannot_process(rating.errors.map { |_attr, msg| msg })
      render json: { error: 'Failed to create resource', messages: rating.errors.full_messages },
             status: :bad_request
    end
    # created_rating = Rating.create(rating_params)
    # render json: RatingSerializer.new(created_rating)
  end

  private

  def rating_params
    params.permit(:user_id, :cocktail_id, :stars)
  end
end
