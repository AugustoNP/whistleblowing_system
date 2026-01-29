module Admin
  class BaseController < ApplicationController
    before_action :require_authentication
    before_action :ensure_admin!

    private

    def ensure_admin!
      unless Current.user&.admin?
        redirect_to root_path, alert: "Acesso restrito: Apenas administradores."
      end
    end
  end
end