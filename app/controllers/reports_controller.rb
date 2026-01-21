class ReportsController < ApplicationController
  # Publicly accessible pages
  allow_unauthenticated_access only: %i[new create show lookup integrity diligence_form]
  
  before_action :set_report, only: %i[show edit update destroy update_status]
  
  # Protect administrative actions
  before_action :require_authentication, except: %i[new create show lookup integrity diligence_form]
  
  # Admin/Diligence authorization for lists
  before_action :authorize_management!, only: %i[index diligence_index destroy]
  
  # STRICT LOCK: Only Admins can access the Whistleblowing Index
  before_action :require_admin_only!, only: %i[index]

  # GET /reports -> WHISTLEBLOWING ONLY (Admin Only)
  def index
    # Strictly only reports without company data
    @reports = Report.where(razao_social: [nil, ""]).order(created_at: :desc)
  end

  # GET /reports/diligence_index -> DUE DILIGENCE ONLY (Admin & Diligence)
  def diligence_index
    # Strictly only company questionnaires
    @reports = Report.where.not(razao_social: [nil, ""]).order(created_at: :desc)
  end

def show
    # Security: Ensure Diligence users can't peek at Whistleblowing via ID manipulation
    if Current.user&.diligence? && @report.razao_social.blank?
      return redirect_to diligence_index_reports_path, alert: "Acesso restrito a questionários de Due Diligence."
    end

    respond_to do |format|
      format.html # Normal web view
      format.pdf do
        # We render the show template with a special 'pdf' layout for A4 formatting
        render pdf: "Diligencia_#{@report.razao_social.parameterize}_#{@report.protocolo}",
               template: "reports/show",
               layout: "pdf", # You'll need a simple pdf.html.erb layout
               page_size: "A4",
               encoding: "UTF-8",
               margin: { top: 10, bottom: 10, left: 10, right: 10 }
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
    # SECURITY LOCK: Admin can view Diligence list but CANNOT edit the records
    if Current.user.admin? && @report.razao_social.present?
      redirect_to diligence_index_reports_path, alert: "Admins possuem apenas permissão de visualização para Due Diligence."
    elsif Current.user.diligence? && @report.razao_social.blank?
      redirect_to reports_path, alert: "Acesso negado aos relatos de ouvidoria."
    else
      # Render correct template if authorized
      @report.razao_social.present? ? render(:edit_diligence) : render(:edit)
    end
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      redirect_to @report, notice: "Enviado com sucesso! Protocolo: #{@report.protocolo}"
    else
      view_to_render = params[:report][:razao_social].present? ? :diligence_form : :new
      render view_to_render, status: :unprocessable_entity
    end
  end

  def update
    # Security: Prevent Admin from bypassing UI to update Diligence data
    if Current.user.admin? && @report.razao_social.present?
      return redirect_to diligence_index_reports_path, alert: "Você não tem permissão para editar este registro."
    end

    if @report.update(report_params)
      # Context-aware redirection to stay in the correct dashboard
      target_path = @report.razao_social.present? ? diligence_index_reports_path : reports_path
      redirect_to target_path, notice: "Atualizado com sucesso."
    else
      view = @report.razao_social.present? ? :edit_diligence : :edit
      render view, status: :unprocessable_entity
    end
  end

def update_status
  if @report.update(status: params[:status])
    respond_to do |format|
      format.turbo_stream do
        # We define the HTML for the row right here to avoid creating a partial file
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
      format.html { redirect_to @report.razao_social.present? ? diligence_index_reports_path : reports_path }
    end
  else
    redirect_to root_path, alert: "Erro ao atualizar status."
  end
end

  def destroy
    # Capture the type before deleting the record to redirect correctly
    is_diligence = @report.razao_social.present?
    @report.destroy!
    
    target_path = is_diligence ? diligence_index_reports_path : reports_path
    redirect_to target_path, notice: "Excluído com sucesso."
  end

  # PUBLIC LOOKUP: Strictly for Whistleblowing protocols only
  def lookup
    if params[:protocolo].present?
      # Filter by razâo_social being blank to block Due Diligence IDs from this tool
      @report = Report.where(razao_social: [nil, ""])
                      .find_by(protocolo: params[:protocolo].upcase.strip)
      
      if @report.nil?
        flash.now[:alert] = "Protocolo de relato não encontrado ou inválido."
      end
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  # Level 1: General Auth
  def authorize_management!
    unless Current.user&.admin? || Current.user&.diligence?
      redirect_to root_path, alert: "Área restrita."
    end
  end

  # Level 2: Specific Whistleblowing Auth
  def require_admin_only!
    # If the user is a diligence analyst but NOT an admin, block access to index
    if Current.user&.diligence? && !Current.user&.admin?
      redirect_to diligence_index_reports_path, alert: "Sua conta possui acesso restrito apenas ao Painel de Diligência."
    end
  end

  def report_params
    params.require(:report).permit(
      :modo, :nome, :email, :categoria, :local, :descricao, :protocolo, :status,
      :razao_social, :cnpj, :nome_fantasia, :website, :endereco, :data_const, :porte, :n_func, :objeto, :paises,
      :r_nome, :r_email, :r_cargo, :ubo, :ubo_txt, :i_pub, :i_pub_txt, :pep, :par, :rel_emp, :rel_emp_txt,
      :conf_int, :restr, :restr_txt, :c_cod, :c_cod_url, :c_pac, :c_pac_url, :c_prog, :c_prog_url,
      :c_bri, :c_bri_url, :c_ddt, :c_ddt_desc, :c_can, :c_can_cont, :anon_ret, :c_trein, :c_mon, :c_mon_desc,
      :cert_basic, :t_usa, :t_claus, :a_nome, :a_cargo, :a_data,
      :oc_txt, :inv, :inv_txt, :imp, :imped_txt, :fal, :fal_txt, 
      oc: [], i_inst: [],
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