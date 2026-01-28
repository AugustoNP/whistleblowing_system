class ReportsController < ApplicationController
  allow_unauthenticated_access only: %i[new create lookup integrity]
  before_action :require_authentication, except: %i[new create lookup integrity]
  before_action :set_report, only: %i[show edit update destroy update_status]

  # Only Admin and RH can see the index or update reports
  before_action :authorize_report_access!, only: %i[index update_status destroy]

  # GET /reports
  def index
    # Now that the table is split, we just grab all Reports (Whistleblowing)
    @reports = Report.order(created_at: :desc)
  end

  # GET /reports/:id
  def show
    # Permission: Admin, RH, and Diligence can see the report.
    # (Diligence is "View Only" as per your mapping)
    unless Current.user.admin? || Current.user.rh? || Current.user.diligence?
      redirect_to root_path, alert: "Acesso negado."
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.status = :pendente # Force status for public submissions

    if @report.save
      notice = "Enviado com sucesso! Protocolo: #{@report.protocolo}"
      redirect_to (Current.user ? reports_path : root_path), notice: notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Reports cannot be edited, but we show the edit view to allow RH/Admin to add observations
    render :edit
  end

  def update
    # PERMISSION MAPPING: Admin/RH can ONLY edit :oc_txt. Diligence cannot edit.
    if Current.user.admin? || Current.user.rh?
      if @report.update(params.require(:report).permit(:oc_txt))
        redirect_to @report, notice: "Observações atualizadas."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @report, alert: "Você não tem permissão para editar observações."
    end
  end

  def update_status
    # Only Admin and RH should change status (Diligence is View Only for reports)
    if (Current.user.admin? || Current.user.rh?) && @report.update(status: params[:status])
      redirect_to reports_path, notice: "Status atualizado."
    else
      redirect_to reports_path, alert: "Não autorizado."
    end
  end

  def lookup
    if params[:protocolo].present?
      @report = Report.find_by(protocolo: params[:protocolo].upcase.strip)
      flash.now[:alert] = "Protocolo não encontrado." if @report.nil?
    end
  end

  def integrity; end

  private

  def set_report
    @report = Report.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to reports_path, alert: "Relato não encontrado."
  end

  def authorize_report_access!
    # Diligence users can see 'show', but shouldn't see the full 'index' of whistleblowers 
    # unless you want them to. Based on your mapping, Admin/RH manage this area.
    unless Current.user.admin? || Current.user.rh?
      redirect_to root_path, alert: "Acesso restrito."
    end
  end

  def report_params
    params.require(:report).permit(:modo, :nome, :email, :categoria, :local, :descricao)
  end
end
