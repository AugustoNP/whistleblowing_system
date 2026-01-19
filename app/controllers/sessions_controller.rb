class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Muitas tentativas. Tente novamente mais tarde." }

  def new
  end

def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      terminate_session
      start_new_session_for(user)
      # Uses the new helper we just added to the concern
      redirect_to after_authentication_url, notice: "Bem-vindo de volta, #{user.username}!"
    else
      redirect_to new_session_path, alert: "E-mail ou senha incorretos."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "Sessão encerrada."
  end
end
