class AuthenticationController < ApplicationController
  def token_auth
    token = params[:auth_token]
    payload = decode(token)
    if User.where('email = ?', payload[:email])
      render json: {in_new: false, token: token}
    else
      User.create!(name: payload[:name], email: payload[:email], google_token: token)
      render json: {is_new: true, token: token}
    end
  end
end
