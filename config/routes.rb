Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    collection do
      post '/login', to: 'users#login'

      post '/register', to: 'users#register'

      put '/update', to: 'users#update'
    end
  end

# ------------------------
#      MEMBER ROUTES    #
# ------------------------

  get '/members/:role', to: 'members#children'

  get '/members', to: 'members#index'

  get '/members/:id', to: 'members#show'

  post '/members', to: 'members#create'

  delete '/members/:id', to: 'members#delete'

  put '/members/:id', to: 'members#update'


  # get '/children', to: 'children#index'

end
