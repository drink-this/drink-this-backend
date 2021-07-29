Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'auth/:provider/callback', to: 'user#create'

  namespace :api do
    namespace :v1 do
      #post 'auth/:provider/callback', to: 'user#create'
      get 'auth/failure', to: redirect('/')
    end
  end
end
