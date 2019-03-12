Rails.application.routes.draw do
  resources :users
  resources :tasks
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


  # ------------------------
  #      Behavior Routes    #
  # ------------------------

  get '/behaviors', to: 'behaviors#index'

  get '/behaviors/:id', to: 'behaviors#show'

  post '/behaviors', to: 'behaviors#create'

  delete '/behaviors/:id', to: 'behaviors#delete'

  put '/behaviors/:id', to: 'behaviors#update'

  # ------------------------
  #      TASK ROUTES    #
  # ------------------------

  get '/tasks', to: 'tasks#index'

  post '/tasks', to: 'tasks#create'

  delete '/tasks/:id', to: 'tasks#delete'

  put '/tasks/:id', to: 'tasks#update'

  # ------------------------
  #     ASSIGN TASK ROUTES    #
  # ------------------------

  resources :tasks do
    collection do
      get '/assignments', to: 'tasks#indexAssignments'

      post '/assignments', to: 'tasks#assignTask'

      delete '/assignments/:id', to: 'tasks#deleteAssignedTask'

      put '/assignments/:id', to: 'tasks#updateAssignedTask'
    end
  end


end
