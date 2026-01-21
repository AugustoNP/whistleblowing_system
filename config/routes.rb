Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :reports do
    # This creates a route like: PATCH /reports/:id/update_status
    member do
      patch :update_status
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "consultar", to: "reports#lookup", as: :lookup_report
  get 'integrity', to: 'reports#integrity'
  root "reports#new"
end