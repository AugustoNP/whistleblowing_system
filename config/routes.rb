Rails.application.routes.draw do
  # Authentication (Rails 8 defaults)
  resource :session
  resources :passwords, param: :token

  # Whistleblowing (Relatos)
  resources :reports do
    member do
      # Dedicated route for toggling status in the dashboard
      patch :update_status
    end
    collection do
      get :lookup    # The page where users enter their protocol
      get :integrity # The public landing page
    end
  end

  # Due Diligence (Gestão de Diligência)
  resources :diligences do
    member do
      # Dedicated route for toggling status in the management table
      patch :update_status
    end
  end

  namespace :admin do
    resources :users
    get 'dashboard', to: 'dashboard#index'
  end

  # Root path points to the Public Integrity Landing Page
  root "reports#integrity"
end