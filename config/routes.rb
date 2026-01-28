Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # --- Whistleblowing (Relatos) ---
  resources :reports do
    member { patch :update_status }
    collection { get :lookup }
  end

  # --- Due Diligence ---
  resources :diligences do
    member { patch :update_status }
    # This keeps your existing URL /reports/diligence_index working if needed, 
    # but it's better to move it to a dedicated index.
  end

  # The Admin Hub
  resources :admin_hub, only: [:index, :edit, :update, :destroy]

  # The Diligence section
  resources :diligences

  # Public paths (Keep these the same so your links don't break)
  get "consultar", to: "reports#lookup", as: :lookup_report
  get "integrity", to: "reports#integrity"
  # Change this to point to the new DiligencesController
  get "diligence_form", to: "diligences#new", as: :due_diligences


  root "reports#integrity"
end
