Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    collection do
      post '/login', to: 'users#login'

      post '/register', to: 'users#register'
    end
  end



end
