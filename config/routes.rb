Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :cocktails, only: :show
      
      namespace :cocktails do
        scope '/:id' do
          resources :rating, only: :create
        end
      end
    end
  end
end
