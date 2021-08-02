Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :users, only: [:create]

  get "/session", to: "session#login"
  get "/token_auth", to: "authentication#token_auth"

  namespace :api do
    namespace :v1 do
      namespace :cocktails do
        resources :search, only: :index

        scope '/:id' do
          resources :rating, only: :create
        end
      end
      
      resources :cocktails, only: :show
    end
  end
end
