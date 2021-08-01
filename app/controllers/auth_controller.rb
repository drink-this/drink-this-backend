class AuthenticationController < ApplicationController

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      payload = user {user_id: user.id}
      token = encode(payload)
      render json: {user: user, token: token}
    else
      render json {error: "User not found"}
    end
  end

  def token_authenticate
    token = request.headers["Authenticate"]
    user = User.find(decode(token))["user_id"]

    render json:user
  end
end
