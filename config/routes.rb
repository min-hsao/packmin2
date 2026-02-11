Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  # Setup wizard
  get 'setup', to: 'setup#index', as: :setup
  post 'setup', to: 'setup#update'
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  
  # Packing lists
  resources :packing_lists, only: [:index, :new, :create, :show, :destroy] do
    member do
      post :regenerate
    end
  end
  
  # Saved locations
  resources :saved_locations
  
  # Custom items
  resources :custom_items
  
  # Activities/presets
  resources :activities
  
  # User settings
  resource :settings, only: [:show, :update]
  
  # Health check for Docker
  get 'up', to: 'rails/health#show', as: :rails_health_check
  
  # Root
  root 'home#index'
end
