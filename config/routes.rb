Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post "/login", to: "sessions#create"
      resource :sessions, only: [ :show, :destroy ]

      resources :users, only: [ :show, :create ] do
        resources :binders, only: [ :create, :update, :destroy ] do
          resources :binder_cards, only: [ :create, :destroy ]
        end
      end
      resources :cards, only: [ :index ]
    end
  end
end
