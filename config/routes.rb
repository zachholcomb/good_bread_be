Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # REGULAR ROUTES
      resources :items, only: [:index, :show]
      resources :orders, only: [:show, :create, :destroy]

      # USER SPECIFIC ROUTES
      resources :users, only: [:show, :update, :destroy] do
        resources :shipments, only: [:index, :show], controller: :users_shipments
        resources :subscription, except: [:new, :index]
        resources :orders, only: [:create, :index], controller: :users_orders
      end

      # ADMIN ROUTES
      namespace :admin do
        resources :users, only: [:index, :show]
        resources :subscriptions, only: [:index, :show]
        resources :items, only: [:new, :create, :update, :destroy]
        resources :shipments, except: [:new]
        resources :orders, only: [:index, :show, :update]
      end

      # SESSIONS
      post '/register', to: 'sessions#new'
      post '/login', to: 'sessions#create'
      post '/refresh', to: 'refresh#create'
      delete '/logout', to: 'sessions#destroy'  
    end
  end
end
  