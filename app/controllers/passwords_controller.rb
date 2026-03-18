class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    if @user.update(password_params)

      @user.update!(force_password_change: false) if @user.force_password_change?


      @user.sessions.where.not(id: Current.session&.id).destroy_all

      redirect_to root_path, notice: "Senha atualizada com sucesso. Acesso liberado!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user_by_token
      # This matches the generates_token_for :password_reset in the model
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
    def set_user
      # If logged in (Forced Change), use Current.user
      # If not logged in (Forgot Password), use the token
      if authenticated?
        @user = Current.user
      else
        @user = User.find_by_password_reset_token!(params[:token])
      end
    rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
      redirect_to new_password_path, alert: "O link de redefinição é inválido ou expirou."
    end

    def password_params
      # Use require/permit to match the form submission
      params.require(:user).permit(:password, :password_confirmation)
    end
end
