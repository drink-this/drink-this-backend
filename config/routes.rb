Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :cocktails do
        resources :search, only: :index

        scope '/:id' do
          resources :rating, only: :create
        end
      end
      
      resources :cocktails, only: :show

      get '/recommendation', to: 'recommendations#show'
    end
  end
end
