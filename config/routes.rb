Rails.application.routes.draw do
  # Authentication
  resource :session

  resource :password, only: [:new, :create, :edit, :update] do
    get "/edit/:token", to: "passwords#edit", as: :edit_with_token
  end

  # Whistleblowing
  resources :reports do
    member do 
      patch :update_status
      get :success
    end

    collection do
      get :lookup
      get :integrity
    end
  end


  resources :diligences do
    resources :diligence_invitations, only: [:new, :create]
    member { patch :update_status }
  end


  namespace :admin do
    resources :diligence_invitations, only: [:new, :create]
    resources :users, only: [:index, :create, :update, :destroy] do
      member do
        patch :update_password
      end
    end
    get 'dashboard', to: 'dashboard#index'
  end

  root "reports#integrity"
end