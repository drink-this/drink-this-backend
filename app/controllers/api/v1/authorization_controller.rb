class Api::V1::AuthorizationController < ApplicationController
  before_action :authorize_user

  def current_user
    @current_user ||= User.find_by(google_token: params[:auth_token]) if params[:auth_token]
  end

  private

  def authorize_user
    return if current_user

    render json: { error: "Couldn't find User" }, status: :not_found
  end
end
