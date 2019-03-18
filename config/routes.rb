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



  # ---------------------------------------------
#      MEMBER ROUTES    #
  # ---------------------------------------------

  get '/members/:role', to: 'members#children'

  get '/members', to: 'members#index'

  get '/members/:id', to: 'members#show'

  post '/members', to: 'members#create'

  delete '/members/:id', to: 'members#delete'

  put '/members/:id', to: 'members#update'


    # ---------------------------------------------
  #      Behavior Routes    #
    # ---------------------------------------------

  get '/behaviors', to: 'behaviors#index'

  post '/behaviors', to: 'behaviors#create'

  delete '/behaviors/:id', to: 'behaviors#delete'

  put '/behaviors/:id', to: 'behaviors#update'

    # ---------------------------------------------
  #     ASSIGN BEHAVIOR ROUTES    #
    # ---------------------------------------------

  resources :behaviors do
    collection do
      get '/assignments', to: 'behaviors#indexBehaviors'

      post '/assignments', to: 'behaviors#assignBehaviors'

      delete '/assignments/:id', to: 'behaviors#deleteAssignedBehavior'

      put '/assignments/:id', to: 'behaviors#updateAssignedBehavior'

    end
  end

    # ---------------------------------------------
  #      TASK ROUTES    #
    # ---------------------------------------------

  get '/tasks', to: 'tasks#index'

  post '/tasks', to: 'tasks#create'

  delete '/tasks/:id', to: 'tasks#delete'

  put '/tasks/:id', to: 'tasks#update'

    # ---------------------------------------------
  #     ASSIGN TASK ROUTES    #
    # ---------------------------------------------

  resources :tasks do
    collection do
      get '/assignments', to: 'tasks#indexAssignments'

      post '/assignments', to: 'tasks#assignTask'

      delete '/assignments/:id', to: 'tasks#deleteAssignedTask'

      put '/assignments/:id', to: 'tasks#updateAssignedTask'
    end
  end



    # ---------------------------------------------
  #      REINFORCEMENT ROUTES    #
    # ---------------------------------------------
  get '/reinforcements', to: 'reinforcements#index'

  post '/reinforcements', to: 'reinforcements#create'

  delete '/reinforcements/:id', to: 'reinforcements#delete'

  put '/reinforcements/:id', to: 'reinforcements#update'

    # ---------------------------------------------
  #     ASSIGN REINFORCEMENT ROUTES    #
    # ---------------------------------------------

  resources :reinforcements do
    collection do
      get '/assignments', to: 'reinforcements#indexReinforcements'

      post '/assignments', to: 'reinforcements#assignReinforcement'

      delete '/assignments/:id', to: 'reinforcements#deleteAssignedReinforcement'

      put '/assignments/:id', to: 'reinforcements#updateAssignedReinforcement'
    end
  end

  # ---------------------------------------------
#      SCORES ROUTES    #
  # ---------------------------------------------

  get '/scores', to: 'scores#index'

  post '/scores', to: 'scores#create'

  delete '/scores/:id', to: 'scores#delete'

  put '/scores/:id', to: 'scores#update'

  patch '/scores/:id', to: 'scores#patch'

end
