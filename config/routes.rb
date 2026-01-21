Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  
  resources :reports do
    member do
      patch :update_status
    end

    collection do
      get :diligence_index # The Compliance Dashboard (Admin/Diligence Only)
      get :lookup          # The Protocol tracking page
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Public facing landing pages and forms
  get "consultar", to: "reports#lookup", as: :lookup_report
  get 'integrity', to: 'reports#integrity'
  get 'diligence_form', to: 'reports#diligence_form', as: :due_diligences
  
  # Root points to the general landing page (Integrity) 
  # rather than just the whistleblowing form, providing better context.
  root "reports#integrity" 
end