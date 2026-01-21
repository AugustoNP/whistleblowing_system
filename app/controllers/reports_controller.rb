class ReportsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create show lookup ]
  before_action :set_report, only: %i[ show edit update destroy update_status ]

  def index
    @reports = Report.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @report = Report.new
  end

  def edit
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      redirect_to @report, notice: "Relato enviado com sucesso! Guarde seu protocolo: #{@report.protocolo}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to @report, notice: "Relato atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    if @report.update(status: params[:status])
      redirect_to reports_path, notice: "Status atualizado para #{@report.status.humanize}."
    else
      redirect_to reports_path, alert: "Erro ao atualizar status."
    end
  end

  def destroy
    @report.destroy!
    redirect_to reports_path, notice: "Relato excluído permanentemente.", status: :see_other
  end

  # MOVED ABOVE PRIVATE:
  def lookup
    if params[:protocolo].present?
      @report = Report.find_by(protocolo: params[:protocolo].upcase.strip)
      
      if @report.nil?
        flash.now[:alert] = "Protocolo não encontrado. Verifique o código e tente novamente."
      end
    end
  end

  private # Methods below this line are not accessible by the router

  def set_report
    @report = Report.find(params.expect(:id))
  end

  def report_params
    params.expect(report: [ :modo, :nome, :email, :categoria, :local, :descricao, :protocolo, :status ])
  end

  def integrity

  end
end 