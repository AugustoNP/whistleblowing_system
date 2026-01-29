Rails.application.routes.draw do
  # Authentication
  resource :session
  resources :passwords, param: :token

  # Whistleblowing
  resources :reports do
    member { patch :update_status }
    collection do
      get :lookup
      get :integrity
    end
  end

  # Due Diligence
  resources :diligences do
    member { patch :update_status }
  end

  # --- MOVE THIS OUTSIDE ---
  namespace :admin do
    resources :users, only: [:index, :create, :update, :destroy] do
      member do
        patch :update_password
      end
    end
    get 'dashboard', to: 'dashboard#index'
  end

  root "reports#integrity"
end