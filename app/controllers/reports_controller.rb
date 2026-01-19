class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update destroy ]

  def index
    @reports = Report.all
  end

  def show
    # Rails automatically renders show.html.erb
  end

  def new
    @report = Report.new
  end

  def edit
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to @report, notice: "Relato enviado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      # Redirects to the "Ver" page after editing
      redirect_to @report, notice: "Relato atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy!
    # Returns to the administration list
    redirect_to reports_path, notice: "Relato excluído permanentemente.", status: :see_other
  end

  private

  def set_report
    # params.expect is a Rails 8 feature. 
    # If you get an error here, use: @report = Report.find(params[:id])
    @report = Report.find(params.expect(:id))
  end

  def report_params
    params.expect(report: [ :modo, :nome, :email, :categoria, :local, :descricao, :protocolo ])
  end
end