class GoogleService

  def self.decode(token)
    response = Faraday.new(url: "https://oauth2.googleapis.com").get("/tokeninfo?id_token=#{token}")
    JSON.parse(response.body, symbolize_names: true)
  end
end
