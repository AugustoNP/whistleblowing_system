class Admin::DiligenceInvitationsController < ApplicationController
  before_action :require_authentication
  before_action :authorize_invitation_access!

  def new
    # Renders the invitation form
  end

def create
  ActiveRecord::Base.transaction do
    @temp_password = SecureRandom.hex(4)

    @user = User.create!(
      username: params[:razao_social],
      email_address: params[:email].downcase.strip,
      password: @temp_password,
      password_confirmation: @temp_password,
      role: :outsider,
      force_password_change: true
    )

    @diligence = Diligence.create!(
      razao_social: params[:razao_social],
      cnpj: params[:cnpj].gsub(/\D/, ''),
      user: @user,
      status: :pendente
    )

    CompanyMailer.invitation_email(@user, @temp_password).deliver_now
  end

  # SUCCESS: Redirect back to the index with a success message
  redirect_to diligences_path, notice: "Empresa #{@user.username} convidada com sucesso!"

rescue ActiveRecord::RecordInvalid => e
  # ERROR: Re-render the form with the specific error message
  flash.now[:alert] = "Não foi possível convidar: #{e.record.errors.full_messages.to_sentence}"
  render :new, status: :unprocessable_entity
rescue StandardError => e
  flash.now[:alert] = "Ocorreu um erro inesperado: #{e.message}"
  render :new, status: :unprocessable_entity
end

  private

  def authorize_invitation_access!
    unless Current.user.admin? || Current.user.diligence?
      redirect_to root_path, alert: "Acesso restrito."
    end
  end
end