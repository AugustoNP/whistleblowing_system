class ReportsController < ApplicationController
  allow_unauthenticated_access only: %i[new create lookup integrity success]
  before_action :require_authentication, except: %i[new create lookup integrity success]
  
  # FIX 1: Removed :destroy
  before_action :set_report, only: %i[show edit update update_status success]

  # FIX 2: Added authorize_report_access to 'index' as well
  before_action :authorize_report_access!, only: %i[index update_status]

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
      redirect_to success_report_path(@report)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Reports cannot be edited, but we show the edit view to allow RH/Admin to add observations
    render :edit
  end

  def update
    if @report.update(params.require(:report).permit(:status, :oc_txt))
      redirect_to reports_path, notice: "Relato atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
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

  def success
  # @report = Report.find(params[:id])
  end

  def integrity; end

  private

  def set_report
    @report = Report.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to reports_path, alert: "Relato não encontrado."
  end

  def authorize_report_access!
    unless Current.user.admin? || Current.user.rh?
      redirect_to root_path, alert: "Acesso restrito ao RH/Administração."
    end
  end

  def report_params
    params.require(:report).permit(:modo, :nome, :email, :categoria, :local, :descricao)
  end
end
