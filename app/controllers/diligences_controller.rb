class DiligencesController < ApplicationController
  before_action :require_authentication
  before_action :set_diligence, only: %i[show edit update destroy]
  before_action :authorize_diligence_access!

  def index
    @diligences = Diligence.order(created_at: :desc)
  end

  def show
    # This will render your complex Section 1-7 matrix
  end

  def new
    @diligence = Diligence.new
  end

  def create
    @diligence = Diligence.new(diligence_params)
    if @diligence.save
      redirect_to @diligence, notice: "Diligência criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    # Renders the analysis form
  end
def update
  @diligence = Diligence.find(params[:id])
  if @diligence.update(diligence_params)
    # Hardcode the redirect to the index page specifically
    redirect_to diligences_path, notice: "Status atualizado com sucesso."
  else
    # If update fails, we still need to show errors
    redirect_to diligences_path, alert: "Erro ao atualizar status."
  end
end

  def destroy
  @diligence.destroy
  redirect_to diligences_path, notice: "Registro de Due Diligence excluído com sucesso.", status: :see_other
  end

def update_status
  @diligence = Diligence.find(params[:id])
  
  # update_columns bypasses validations and saves only the status field
  if @diligence.update_columns(status: params[:status])
    redirect_to diligences_path, notice: "Status atualizado com sucesso."
  else
    redirect_to diligences_path, alert: "Erro ao atualizar status."
  end
end
  private

  def set_diligence
    @diligence = Diligence.find(params[:id])
  end

  def authorize_diligence_access!
    unless Current.user.admin? || Current.user.diligence?
      redirect_to root_path, alert: "Acesso restrito à área de Compliance."
    end
  end

  def diligence_params
    params.require(:diligence).permit(
      :razao_social, :cnpj, :nome_fantasia, :endereco, :website, :r_nome, :r_cargo, :r_email, 
      :c_cod, :c_can, :c_trein, :c_mon, :i_pub, :ubo, :restr, :status, :oc_txt,
      socios_attributes: [:id, :nome, :cargo, :percent, :_destroy],
      empresa_vinculadas_attributes: [:id, :razao, :cnpj, :tipo, :_destroy],
      participacao_socios_attributes: [:id, :socio, :empresa, :cnpj, :_destroy],
      peps_attributes: [:id, :nome, :orgao, :cargo, :_destroy],
      parentescos_attributes: [:id, :integrante, :agente, :orgao, :_destroy],
      licencas_attributes: [:id, :tipo, :orgao, :validade, :_destroy],
      terceiros_attributes: [:id, :razao, :cnpj, :atividade, :_destroy]
    )
  end
end