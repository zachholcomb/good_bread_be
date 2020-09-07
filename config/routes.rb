Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # USER SPECIFIC ROUTES
      resources :users, except: [:new] do
        resources :shipments, only: [:index, :show], controller: :users_shipments
        resources :subscription, only: [:create, :update, :destroy]
      end

      # ADMIN ROUTES
      resources :subscriptions, only: [:index, :show]
      resources :items, except: [:new]
      resources :shipments, except: [:new]

      # SESSIONS
      post '/register', to: 'sessions#new'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'  
    end
  end
end
  