class Api::V1::UsersController < ApplicationController

  def create
    user = User.create_from_omniauth(auth_hash)

    # Access_token is used to authenticate request made from the rails application to the google server
    user.google_token = auth_hash.credentials.token

    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = auth_hash.credentials.refresh_token

    #Google assumes that you have stored the value and would not send it again.
    user.google_refresh_token = refresh_token if refresh_token.present?

    if user.save
      render json: UserSerializer.new(user), status: :created
    else
      #render json: UserSerializer.new(user), status: :no_content
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
