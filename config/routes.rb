Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :users, only: [:create]

  get "/session", to: "session#login"
  get "/login", to: "authentication#token_authenticate"
end
