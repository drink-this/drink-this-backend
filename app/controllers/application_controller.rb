class ApplicationController < ActionController::API

  def secret_key
    "drinkthis"
  end

  def encode(payload)
    JWT.encode(payload, secret_key, 'HS256')
  end

  def decode(token)
    JWT.decode(token, "drinkthis", true, {algorithm: "HS256"})[0]
  end
end
