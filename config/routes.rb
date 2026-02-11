Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  delete "/logout", to: "sessions#destroy"

  # Setup wizard
  get "/setup", to: "setup#show"
  patch "/setup", to: "setup#update"

  # Dashboard
  root "dashboard#show"

  # Packing Lists
  resources :packing_lists, only: [:index, :show, :new, :create, :destroy] do
    member do
      post :regenerate
    end
  end

  # User resources
  resources :saved_locations
  resources :custom_items
  resources :activities

  # Settings
  get "/settings", to: "settings#show"
  patch "/settings", to: "settings#update"
end
