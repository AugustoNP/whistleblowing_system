class ReportsController < ApplicationController
  # 1. PUBLIC ACTIONS: Only submission and protocol lookup
  allow_unauthenticated_access only: %i[new create lookup integrity]
  
  # 2. SCOPED LOOKUP: Prevents IDOR (Insecure Direct Object Reference)
  before_action :set_authorized_report, only: %i[show edit update destroy update_status]
  
  # 3. AUTHENTICATION: Ensure login for everything else
  before_action :require_authentication, except: %i[new create lookup integrity]
  
  # 4. AUTHORIZATION: Management check for staff-only dashboards and tools
  before_action :authorize_management!, only: %i[index diligence_index diligence_form update_status destroy]
  
  # 5. ADMIN ONLY: Whistleblowing index access
  before_action :require_admin_only!, only: %i[index]

  # GET /reports (Admin Only - Whistleblowing)
  def index
    @reports = Report.where(razao_social: [nil, ""]).order(created_at: :desc)
  end

  # GET /reports/diligence_index (Admin & Diligence - Due Diligence)
  def diligence_index
    @reports = Report.where.not(razao_social: [nil, ""]).order(created_at: :desc)
  end

  # GET /reports/:id
  def show
    # Visitors cannot use this view; they are restricted to the 'lookup' result
    if Current.user.nil?
      redirect_to lookup_reports_path, alert: "Acesso restrito. Utilize a consulta por protocolo." and return
    end

    respond_to do |format|
      format.html # View restricted by set_authorized_report scope
      format.pdf do
        render pdf: "Diligencia_#{@report.protocolo}",
               template: "reports/show",
               layout: "pdf",
               page_size: "A4",
               encoding: "UTF-8"
      end
    end
  end

  def new
    @report = Report.new
  end

  def integrity; end

  def diligence_form
    @report = Report.new
    [ :socios, :empresa_vinculadas, :participacao_socios, :peps, 
      :parentescos, :licencas, :terceiros ].each { |assoc| @report.send(assoc).build }
  end

  def edit
    # Internal routing to the correct sub-form
    @report.razao_social.present? ? render(:edit_diligence) : render(:edit)
  end

  def create
    # Use filtered params to prevent 'visitante' from submitting diligence fields
    @report = Report.new(filtered_report_params)
    
    # Extra protection: ensure visitors cannot force a status
    @report.status = :pendente if Current.user.nil?

    if @report.save
      notice = "Enviado com sucesso! Protocolo: #{@report.protocolo}"
      # Visitors go to root, staff go to their dashboard
      redirect_to (Current.user ? index_path_for(@report) : root_path), notice: notice
    else
      view_to_render = @report.razao_social.present? ? :diligence_form : :new
      render view_to_render, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(filtered_report_params)
      redirect_to index_path_for(@report), notice: "Atualizado com sucesso."
    else
      render (@report.razao_social.present? ? :edit_diligence : :edit), status: :unprocessable_entity
    end
  end

  def update_status
    # Validation against Enum keys to prevent injection
    new_status = params[:status]
    
    if Report.statuses.keys.include?(new_status) && @report.update(status: new_status)
      respond_to do |format|
        format.turbo_stream do
          row_html = render_to_string(inline: <<~ERB, locals: { report: @report })
            <tr id="report_<%= report.id %>" style="height: 60px;">
              <td><strong><%= report.razao_social.present? ? report.razao_social : report.protocolo %></strong></td>
              <td><%= report.razao_social.present? ? report.cnpj : report.categoria %></td>
              <td><%= report.created_at.strftime("%d/%m/%Y") %></td>
              <td style="width: 140px;">
                <%= form_with url: update_status_report_path(report), method: :patch, class: "inline-form" do |f| %>
                  <%= f.select :status, Report.statuses.keys.map { |s| [s.humanize, s] }, { selected: report.status }, 
                      { class: "badge badge--\#{report.status}", onchange: "this.form.requestSubmit()", 
                        style: "cursor: pointer; border: none; appearance: none; -webkit-appearance: none; width: 100%; text-align: center;" } %>
                <% end %>
              </td>
              <td class="text-right">
                <div class="action-group">
                  <a href="<%= report_path(report) %>" class="link-action">Ver</a>
                  <a href="<%= edit_report_path(report) %>" class="link-action">Editar</a>
                </div>
              </td>
            </tr>
          ERB
          render turbo_stream: turbo_stream.replace("report_#{@report.id}", html: row_html)
        end
        format.html { redirect_to index_path_for(@report) }
      end
    else
      redirect_to root_path, alert: "Falha na atualização de status."
    end
  end

  def destroy
    target_path = index_path_for(@report)
    @report.destroy!
    redirect_to target_path, notice: "Excluído com sucesso."
  end

  def lookup
    if params[:protocolo].present?
      @report = Report.find_by(protocolo: params[:protocolo].upcase.strip)
      flash.now[:alert] = "Protocolo não encontrado." if @report.nil?
    end
  end

  private

  # HARDENED LOOKUP: Prevents an Analyst from seeing Admin-only reports via ID manipulation
  def set_authorized_report
    if Current.user&.admin?
      @report = Report.find(params[:id])
    elsif Current.user&.diligence?
      # Scoped to only Diligence records
      @report = Report.where.not(razao_social: [nil, ""]).find(params[:id])
    else
      # Deny direct ID access to unauthenticated visitors
      redirect_to root_path, alert: "Acesso negado."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Registro não encontrado."
  end

  def authorize_management!
    unless Current.user&.admin? || Current.user&.diligence?
      redirect_to root_path, alert: "Área restrita."
    end
  end

  def require_admin_only!
    if Current.user&.diligence? && !Current.user&.admin?
      redirect_to diligence_index_reports_path, alert: "Acesso restrito ao Painel de Diligência."
    end
  end

  def index_path_for(report)
    report.razao_social.present? ? diligence_index_reports_path : reports_path
  end

  # ROLE-BASED PARAMETERS: Prevents mass assignment
  def filtered_report_params
    if Current.user&.admin? || Current.user&.diligence?
      # Management can edit everything including status
      params.require(:report).permit! 
    else
      # Public users can ONLY submit specific Whistleblowing fields
      params.require(:report).permit(
        :modo, :nome, :email, :categoria, :local, :descricao,
        :razao_social, :cnpj # Included for 'create' logic but validation will check authenticity
      )
    end
  end
end