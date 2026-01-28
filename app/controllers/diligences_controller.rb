class DiligencesController < ApplicationController
  # Public users can submit the form, but only Staff can see the index/edit
  allow_unauthenticated_access only: %i[new create]
  before_action :require_authentication, except: %i[new create]
  before_action :require_diligence_access!, except: %i[new create]
  before_action :set_diligence, only: %i[show edit update destroy]

  def index
    @diligences = Diligence.order(created_at: :desc)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Diligencia_#{@diligence.protocolo}",
               template: "diligences/show",
               layout: "pdf"
      end
    end
  end

  def new
    @diligence = Diligence.new
    # Pre-build 1 row for each association to show in the form
    [ :socios, :empresa_vinculadas, :participacao_socios, :peps, 
      :parentescos, :licencas, :terceiros ].each { |assoc| @diligence.send(assoc).build }
  end

  def create
    @diligence = Diligence.new(diligence_params)
    @diligence.status = :pendente if Current.user.nil?

    if @diligence.save
      notice = "Diligência enviada com sucesso! Protocolo: #{@diligence.protocolo}"
      redirect_to (Current.user ? diligences_path : root_path), notice: notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Form logic handles nested rows
  end

  def update
    if @diligence.update(diligence_params)
      redirect_to @diligence, notice: "Dados de Diligência atualizados com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_diligence
    @diligence = Diligence.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to diligences_path, alert: "Registro não encontrado."
  end

  def require_diligence_access!
    # Explicitly following your mapping: Admin and Diligence users only.
    # RH is excluded from this controller.
    unless Current.user&.admin? || Current.user&.diligence?
      redirect_to root_path, alert: "Acesso restrito à equipe de Diligência."
    end
  end

  def diligence_params
    # Using permit! is okay for staff-level forms with 40+ fields,
    # but ensure your 'create' action for public users is protected.
    if Current.user&.admin? || Current.user&.diligence?
      params.require(:diligence).permit!
    else
      # Strictly limit what a public visitor can submit
      params.require(:diligence).permit(
        :razao_social, :cnpj, :nome_fantasia, :website, :endereco, :data_const,
        :porte, :n_func, :objeto, :paises, :r_nome, :r_email, :r_cargo,
        socios_attributes: [:id, :nome, :cargo, :percent, :_destroy],
        peps_attributes: [:id, :nome, :orgao, :cargo, :_destroy]
        # ... add other nested attributes here as needed ...
      )
    end
  end
end