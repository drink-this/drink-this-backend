class SessionsController < ApplicationController

  def create
    # Get access tokens from the google server
    user = User.create_from_omniauth(auth_hash)

    # Access_token is used to authenticate request made from the rails application to the google server
    user.google_token = auth_hash.credentials.token

    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = auth_hash.credentials.refresh_token

    #Google assumes that you have stored the value and would not send it again.
    user.google_refresh_token = refresh_token if refresh_token.present?

    user.save

    #cookies.encrypted[:current_user_id] = {value: user.id, expires: Time.now + 4.days }
  end

  def destroy
    session[:user_id] = nil
    #cookies.encrypted[:current_user_id] = nil

    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
