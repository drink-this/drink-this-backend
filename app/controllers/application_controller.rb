class ApplicationController < ActionController::API
  rescue_from JWT::DecodeError, with: :error_invalid

  def secret_key
    ENV['GOOGLE_CLIENT_SECRET']
  end

  def encode(payload)
    JWT.encode(payload, secret_key, 'HS256')
  end

  def decode(token)
    response = Faraday.new(url: "https://oauth2.googleapis.com").get("/tokeninfo?id_token=#{token}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def error_invalid
    render json: {error: 'invalid token'}
  end
end
