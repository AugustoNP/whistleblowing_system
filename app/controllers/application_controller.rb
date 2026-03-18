class ApplicationController < ActionController::Base
  include Authentication
  # This ensures that even on "Guest" pages, we check if an admin is present
  # so the menu shows "Sair" instead of "Login".
  before_action :resume_session
  before_action :check_password_change_required

  private

  def check_password_change_required
    return unless authenticated?
    
    # If forced change is true AND they aren't already on the password edit/update actions
    if Current.user.force_password_change? && !on_allowed_page?
      redirect_to edit_password_path, alert: "Alteração de senha obrigatória no primeiro acesso."
    end
  end

  def on_allowed_page?
    # List the pages they ARE allowed to see while locked
    (controller_name == 'passwords' && %w[edit update].include?(action_name)) || 
    controller_name == 'sessions'
  end
end