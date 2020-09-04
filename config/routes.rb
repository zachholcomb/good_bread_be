Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, except: [:new] do
        resources :shipments, only: [:index, :show], controller: :users_shipments
        resources :subscription, only: [:create, :update, :destroy]
      end
      resources :subscriptions, only: [:index, :show]
      resources :items, except: [:new]
      resources :shipments, except: [:new]
    end
  end
end
  