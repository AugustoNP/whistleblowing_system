module UiHelper
  def ui_email_input(form, attribute, label: "E-mail", autofocus: false, placeholder: "exemplo@empresa.com")
    content_tag :div, class: "form-field" do
      concat form.label attribute, label
      concat form.email_field attribute, 
              required: true, 
              autofocus: autofocus, 
              autocomplete: "username", 
              placeholder: placeholder, 
              value: params[attribute], # RESTAURADO: Mantém o input após erro
              class: "form-input",
              style: "box-sizing: border-box;" # CORREÇÃO: Alinhamento horizontal
    end
  end

  # Novo: Campo de texto para Razão Social/CNPJ mantendo o padrão
  def ui_text_input(form, attribute, label: nil, placeholder: nil, autofocus: false, data: {})
    content_tag :div, class: "form-field" do
      concat form.label attribute, label if label
      concat form.text_field attribute, 
              required: true, 
              autofocus: autofocus, 
              placeholder: placeholder, 
              class: "form-input",
              style: "box-sizing: border-box;",
              data: data
    end
  end

  def ui_form_feedback(object = nil)
    if object&.errors&.any?
      content_tag :div, object.errors.full_messages.to_sentence(last_word_connector: " e "), class: "report-form__feedback report-form__feedback--error"
    elsif flash[:alert]
      content_tag :div, flash[:alert], class: "report-form__feedback report-form__feedback--error"
    elsif flash[:notice] # Adicionado suporte para mensagens de sucesso
      content_tag :div, flash[:notice], class: "report-form__feedback report-form__feedback--success"
    end
  end

  def ui_password_input(form, attribute, label: "Senha", show_rules: false)
    content_tag :div, class: "form-field", data: { controller: "sessions" } do
      concat form.label attribute, label

      # Mantendo o ui-input-group e display flex original, mas garantindo o box-sizing
      concat(content_tag(:div, class: "ui-input-group", style: "position: relative; display: flex; align-items: center; width: 100%; box-sizing: border-box;") do
        concat form.password_field attribute, 
               class: "form-input", 
               placeholder: "••••••",
               style: "padding-right: 45px; box-sizing: border-box; width: 100%;",
               data: { 
                 sessions_target: "password", 
                 action: "input->sessions#check" 
               }

        # RESTAURADO: Sua classe original ui-eye-btn
        concat(button_tag(type: "button", data: { action: "click->sessions#toggle" }, class: "ui-eye-btn") { ui_eye_icons })
      end)

      if show_rules
        concat(content_tag(:div, class: "password-rules", style: "margin-top: 0.5rem; font-size: 0.8rem;") do
          concat ui_rule_item("length", "Mínimo 8 caracteres")
          concat ui_rule_item("number", "Contém um número")
          concat ui_rule_item("special", "Contém um símbolo (@, #, $)")
          concat ui_rule_item("nospace", "Não contém espaços")
        end)
      end
    end
  end

  def ui_submit(form, label, disable_with: "Processando...")
    form.submit label, 
      class: "button button--primary", 
      style: "width: 100%; box-sizing: border-box;",
      data: { disable_with: disable_with }
  end

  private

  def ui_rule_item(rule, text)
    content_tag :div, data: { sessions_target: "requirement", rule: rule }, style: "color: #6c757d; transition: color 0.2s; display: flex; align-items: center; margin-bottom: 4px;" do
      concat content_tag(:span, "○", class: "status-icon", style: "margin-right: 8px; font-family: monospace;")
      concat text
    end
  end

  def ui_eye_icons
    raw <<-SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-sessions-target="eyeOpen"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-sessions-target="eyeClose" style="display: none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
    SVG
  end
end